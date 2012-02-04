class Report < ActiveRecord::Base
	belongs_to :user

  def parse
    doc = Nokogiri::HTML(text)

    doc.css('.Data > tr').each do |row|
      data = row.text.split(/\r\n\t+/m)
      time, location, plan, kind, amount = data[0], data[1], data[3], data[6], data[7]

      next if location !~ /Novack|Collis|Commons|Courtyard|King/i

      if plan =~ /SmartChoice/
        user.create_swipe(:location => location, :time => )
    end

  end

  handle_asynchronously :parse
end
