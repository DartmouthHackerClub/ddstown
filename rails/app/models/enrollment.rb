class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  belongs_to :term

  validates_uniqueness_of :term_id, :scope => :user_id

end
