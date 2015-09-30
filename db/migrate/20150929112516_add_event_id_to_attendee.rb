class AddEventIdToAttendee < ActiveRecord::Migration
  def change
    add_reference :attendees, :event, index: true, foreign_key: true
  end
end
