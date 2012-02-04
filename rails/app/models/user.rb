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
    Plan.find(Enrollment.joins(:term).where(:user_id => self).order('start DESC')[0].plan_id)
  end

  def remaining_dba
    self.current_plan.dba - self.purchases.sum(:amount)
  end

  def spent_at(location)
    Purchase.where(:user_id => self, :location => location).sum(:amount)
  end

end
