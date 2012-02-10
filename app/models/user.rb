class User < ActiveRecord::Base
  has_many :swipes
  has_many :purchases

  has_many :reports

  has_many :enrollments
  has_many :plans, :through => :enrollments
  
  devise :cas_authenticatable, :trackable
  
  def pretty
    username[/(.+)@/, 1]
  end

  def current_plan
    Plan.find(Enrollment.joins(:term).where(:user_id => self).order('start DESC').first.plan_id)
  end

  def remaining_dba
    self.current_plan.dba - self.purchases.sum(:amount)
  end

  def spent_on(day)
    Purchase.where(:user_id => self, :time => day..day.tomorrow).sum(:amount)
  end

  def spent_at(location)
    Purchase.where(:user_id => self, :location => location).sum(:amount)
  end

  def has_plan_this_term
    not self.enrollments.where(:term_id => Term.current_term).empty?
  end

  def change_plan(plan_name)
    new_plan = Plan.where(:name => plan_name).first
    # don't change anything if the plan isn't valid
    if new_plan
      current_term = Term.current_term
      
      # delete current enrollment
      current_enrollment = Enrollment.joins(:term).where(:term_id => current_term, :user_id => self).first
      if current_enrollment
        self.enrollments.delete(current_enrollment)
      end
      
      # create and save new enrollment
      self.enrollments.create(:term_id => current_term, :plan => new_plan)
    end
  end

end
