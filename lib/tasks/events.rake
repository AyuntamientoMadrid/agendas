namespace :events do

  desc "Update event status to done"
  task update_event_status: :environment do
    Event.where("scheduled <= ? AND status = ?", Time.zone.today, 1).each do |event|
      event.update(status: :done)
      puts "Event updated"
    end
  end

  desc "Update old event status to done or accepted"
  task update_old_event_status: :environment do
    puts "Starting conversion of old events without status"
    Event.where("status is ?", nil).each do |event|
      if event.scheduled.present?
        if event.scheduled > Time.zone.today
          event.update(status: :accepted)
          puts "Event updated to accepted"
        else
          event.update(status: :done)
          puts "Event updated to done"
        end
      end
    end
  end

end
