class Attachment < ActiveRecord::Base

  # Relations
  belongs_to :event

  # Attachment
  has_attached_file :file

  # Validations
  validates :title, presence: true
  validates :event, presence: true

end
