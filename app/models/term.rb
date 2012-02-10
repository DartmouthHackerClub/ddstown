class Term < ActiveRecord::Base
  has_many :enrollments

  def self.current_term
    Term.where("start < \"#{Date.today.strftime('%Y-%m-%d')}\"").order('end DESC').first
  end

end
