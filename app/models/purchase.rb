class Purchase < ActiveRecord::Base
  belongs_to :user

  scope :since, lambda { |time| where("time > ?", time) }

  def self.by_day
    group_by("DATE(time)").map { |day, purchases| purchases }
  end

end
