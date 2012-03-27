class Purchase < ActiveRecord::Base
  belongs_to :user

  def day
    time.to_date.to_s(:db)
  end
end
