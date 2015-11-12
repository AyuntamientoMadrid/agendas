class Attachment < ActiveRecord::Base

  # Relations
  belongs_to :event

  # Attachment
  has_attached_file :file
  validates_attachment_content_type :file, content_type: ["application/pdf"], message: I18n.t('backend.allowed_file_content_types')

  # Validations
  validates :title, presence: true

end
