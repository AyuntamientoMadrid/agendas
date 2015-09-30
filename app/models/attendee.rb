class Attendee < ActiveRecord::Base

  # Relations
  belongs_to :event

  # Validations
  validates :name, presence: true
  validates :position, presence: true
  validates :company, presence: true

end
