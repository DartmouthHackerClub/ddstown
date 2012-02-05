class Report < ActiveRecord::Base
  belongs_to :user

  def parse
    puts "hi"
    doc = Nokogiri::HTML(html)

    doc.css('.Data tr').each do |row|
      data = row.text.split(/\r\n\t+/m)
      puts data
      time, location, plan, kind, amount = data[0], data[1], data[3], data[6], data[7]

      next if location !~ /Novack|Collis|Commons|Courtyard|King/i


      if plan =~ /SmartChoice/
        
        # parse the datetime
        if time =~ /(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2})/
          d = DateTime.new($3.to_i, $1.to_i, $2.to_i, $4.to_i, $5.to_i, $6.to_i, '-5')
        else
          raise 'Failed to parse datetime'
        end

        user.swipes.find_or_create_by_location_and_time(location, d)

        # enroll for this term or update plan if already enrolled
        if not user.has_plan_this_term
          user.enrollments.create(:term_id => Term.current_term, :plan_id => Plan.where(:name => plan))
        elsif user.current_plan.name != plan
          user.change_plan(plan)
        end
          
          
      elsif plan =~ /Dining/
        user.purchases.create(:location => location, :amount => amount.to_i, :time => time)
      end
    end

  end

  #handle_asynchronously :parse
end
