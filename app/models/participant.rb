class Participant < ActiveRecord::Base

  # Relations
  belongs_to :position
  belongs_to :event

  # Validations
  # validates_uniqueness_of :position_id, scope: :event_id

end
