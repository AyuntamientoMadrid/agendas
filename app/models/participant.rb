class Participant < ActiveRecord::Base

  # Relations
  belongs_to :position
  belongs_to :event

  # Validations
  validates_presence_of :position, :event

end
