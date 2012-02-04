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

  def process_html(html)
    
  end
  handle_asynchronously :process_html
end