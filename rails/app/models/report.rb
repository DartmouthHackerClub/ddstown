class Report < ActiveRecord::Base
	belongs_to :user

  def parse
    
  end
  handle_asynchronously :parse
end
