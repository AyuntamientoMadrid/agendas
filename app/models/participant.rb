class Participant < ActiveRecord::Base

  # Relations
  belongs_to :position
  belongs_to :participants_event, class_name: "Event", foreign_key: "event_id"

  # Validations
  # validates_uniqueness_of :position_id, scope: :event_id

end
