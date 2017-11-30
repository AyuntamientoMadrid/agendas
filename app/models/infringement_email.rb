class InfringementEmail
  extend ActiveModel::Callbacks
  include ActiveModel::Model
  include Paperclip::Glue

  # Paperclip required callbacks
  define_model_callbacks :save, only: [:after]
  define_model_callbacks :commit, only: [:after]
  define_model_callbacks :destroy, only: [:before, :after]

  attr_accessor :subject, :description, :link, :attachment,
                :attachment_content_type, :attachment_file_size, :attachment_file_name, :attachment_updated_at

  has_attached_file :attachment, content_type: ['image/bmp', 'image/jpeg', 'image/jpg', 'image/png',
                                                'application/x-rar-compressed', 'application/octet-stream', 'application/zip']

  def initialize(subject=nil, description=nil, link=nil, attachment=nil)
    @subject = subject
    @description = description
    @link = link
    @attachment = attachment
  end

  def save
    run_callbacks :save do
      self.id = 1000 + Random.rand(9000)
    end
    true
  end

  def destroy
    run_callbacks :destroy
  end

  def updated_at_short
    Time.now.to_s(:autosave_time)
  end

  def errors
    obj = Object.new
    def obj.[](_key)
      []
    end

    def obj.full_messages
      []
    end

    def obj.any?
      false
    end
    obj
  end

  def clear(*styles_to_clear)
    if styles_to_clear.any?
      queue_some_for_delete(*styles_to_clear)
    else
      queue_all_for_delete
      @queued_for_write  = {}
      @errors            = {}
    end
  end
end
