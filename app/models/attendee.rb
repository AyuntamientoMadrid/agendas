class Attendee < ActiveRecord::Base

  belongs_to :event

  validates :name, presence: true
  validates :position, presence: true
  validates :company, presence: true
end
