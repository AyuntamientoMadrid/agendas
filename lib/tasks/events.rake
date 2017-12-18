namespace :events do

  desc "Update event status to done"
  task :update_event_status => :environment do
    Event.where("scheduled <= ? AND status = ?", Date.today, 1).each do |event|
      event.update(status: :done)
    end
  end

end
