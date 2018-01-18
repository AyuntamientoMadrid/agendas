class InfringementEmail
  ATTRIBUTES = [:subject, :description, :link, :attachment, :affected, :affected_referer].freeze
  attr_accessor(*ATTRIBUTES)

  include ActiveModel::Model
  include Paperclip::Glue
  extend ActiveModel::Callbacks

  define_model_callbacks :save, only: [:after]
  define_model_callbacks :commit, only: [:after]
  define_model_callbacks :destroy, only: [:before, :after]

  has_attached_file :attachment
  validates_attachment :attachment, content_type: { content_type: ['image/bmp', 'image/jpeg', 'image/jpg', 'image/png',
                                                                   'application/x-rar-compressed',
                                                                   'application/octet-stream',
                                                                   'application/zip'] },
                                    size: { in: 0..3.megabytes }
  attr_accessor :attachment_file_size, :attachment_file_name, :attachment_content_type, :id
  validates :affected, presence: true

end
