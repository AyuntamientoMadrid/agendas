class Participant < ActiveRecord::Base
  belongs_to :position
  belongs_to :participants_event, class_name: "Event", foreign_key: "event_id"
end
