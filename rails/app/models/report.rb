class Report < ActiveRecord::Base
  belongs_to :user

  def parse
    doc = Nokogiri::HTML(html)

    doc.css('.Data tr').each do |row|
      begin
        data = row.text.split(/\n+/).map { |s| s.strip }
        time = DateTime.strptime("#{data[0]} -5", "%m/%d/%Y %H:%M:%S %z")
        location = data[1]
        plan = data[3]
        kind = data[6]
        amount = data[7].gsub(/\$/, '')

        next if location !~ /Novack|Collis|Commons|Courtyard|King/i

        if plan =~ /SmartChoice/
          user.swipes.find_or_create_by_location_and_time(location, time)

          # enroll for this term or update plan if already enrolled
          if not user.has_plan_this_term
            user.enrollments.create(:term_id => Term.current_term, :plan_id => Plan.where(:name => plan))
          elsif user.current_plan.name != plan
            user.change_plan(plan)
          end

        elsif plan =~ /Dining/
          exists = user.purchases.where(:location => location, :time => time).first
          unless exists
            user.purchases.create(:location => location, :amount => amount.to_i, :time => time)
          end
        end
      rescue Exception => e
        puts e.message
        next
      end
    end
  end
end
