class Report < ActiveRecord::Base
  # a report is a wrapper around html from one of our sources (bannerStudent or manageMyId
  # a report is NOT what a user sees

  belongs_to :user

  #validates :type, :inclusion => { :in => ["banner", "managemyid"], 
  #                                 :message => "%{value} is not a valid type" }

  

  def normalize_location(location)
    case location
    when /novack/i
      "Novack Cafe"
    when /collis/i
      "Collis Cafe"
    when /commons/i
      "Commons Cafe"
    when /king/i
      "King Arthur Flour Cafe"
    when /courtyard/i
      "Courtyard Cafe"
    else
      raise "Unknown Location #{location}"
    end
  end

  def parse
    if self.source == "banner"
      parse_banner
    elsif self.source == "managemyid"
      parse_managemyid
    else
      raise "Invalid source #{self.source}"
    end
  end

  def parse_banner
    doc = Nokogiri::HTML(html)

    # Skip header row
    doc.css('.sortable tr')[1..-1].each do |row|
      puts row
      data = row.text.split(/\n/).map { |x| x.strip }
      begin
        location = normalize_location(data[1])
        date = DateTime.new(data[0])
        amount = data[2].to_i.abs
      rescue
        next
      end

      user.purchases.find_or_create_by_location_and_time(location, time)
    end
  end

  def parse_managemyid
    doc = Nokogiri::HTML(html)

    doc.css('.Data tr').each do |row|
      begin
        data = row.text.split(/\n+/).map { |s| s.strip }
        time = DateTime.strptime("#{data[0]} -5", "%m/%d/%Y %H:%M:%S %z")
        location = normalize_location(data[1])
        plan = data[3]
        kind = data[6]
        amount = data[7].gsub(/\$/, '')

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
