class Report < ActiveRecord::Base
	belongs_to :user

  def parse
    doc = Nokogiri::HTML(html)

    doc.css('.Data tr').each do |row|
      data = row.text.split(/\r\n\t+/m)
      time, location, plan, kind, amount = data[0], data[1], data[3], data[6], data[7]

      next if location !~ /Novack|Collis|Commons|Courtyard|King/i


      if plan =~ /SmartChoice/
        user.swipes.create(:location => location, :time => time)
      elsif plan =~ /Dining/
        user.purchases.create(:location => location, :amount => amount, :time => time)
      end
    end

  end

  #handle_asynchronously :parse
end
