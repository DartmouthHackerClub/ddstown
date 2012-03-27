class Purchase < ActiveRecord::Base
  belongs_to :user

  def self.since(time)
    find(:all, :conditions => ['time > ?', time])
  end

  def self.by_day
    group_by("DATE(time)").map { |day, purchases| purchases }
  end

end
