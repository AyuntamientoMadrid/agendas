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
    puts "Starting conversion of old events without status to accepted"
    Event.where("status is ? AND scheduled > ?", nil, Time.zone.today).update_all(status: :accepted, lobby_activity: false)
    puts "Finished conversion of old events without status to accepted"

    puts "Starting conversion of old events without status to done"
    Event.where("status is ? AND scheduled <= ?", nil, Time.zone.today).update_all(status: :done, lobby_activity: false)
    puts "Finished conversion of old events without status to done"
  end

end
