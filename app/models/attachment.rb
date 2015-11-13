class Attachment < ActiveRecord::Base

  # Relations
  belongs_to :event

  # Attachment
  has_attached_file :file,
      :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_file_name",
      :url => "/system/:attachment/:id/:style/:normalized_file_name"

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end


  validates_attachment_content_type :file, content_type: ["application/pdf"], message: I18n.t('backend.allowed_file_content_types')

  # Validations
  validates :title, presence: true

  def normalized_file_name
    "#{self.file_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end


end
