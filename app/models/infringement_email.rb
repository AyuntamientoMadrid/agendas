class InfringementEmail
  include ActiveModel::Model

  ATTRIBUTES = %i(subject description link attachment)

  attr_accessor(*ATTRIBUTES)


  # >>> Start of Paperclip required stuff to work outside AR
  extend ActiveModel::Callbacks
  include Paperclip::Glue

  define_model_callbacks :save, only: [:after]
  define_model_callbacks :commit, only: [:after]
  define_model_callbacks :destroy, only: [:before, :after]

  has_attached_file :attachment
  validates_attachment :attachment, content_type: {content_type: ['image/bmp','image/jpeg', 'image/jpg', 'image/png',
     'application/x-rar-compressed', 'application/octet-stream', 'application/zip']}, size: {in: 0..3.megabytes}
  attr_accessor :attachment_file_size, :attachment_file_name, :attachment_content_type, :id

  # <<< End Paperclip required stuff

  def initialize(attributes = {})
    super(attributes)
  end

end
