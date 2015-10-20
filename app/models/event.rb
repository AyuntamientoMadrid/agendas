class Event < ActiveRecord::Base

  #friendly-id

  extend FriendlyId
  friendly_id :title, use: :slugged


  # Relations
  belongs_to :user
  belongs_to :position
  has_many :participants
  has_many :positions, through: :participants
  has_many :attachments, dependent: :destroy
  has_many :attendees

  # Validations
  validates_presence_of :title, :position

  # Nested models
  accepts_nested_attributes_for :attendees, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :participants, allow_destroy: true


  def self.to_csv
    attributes = %w{id title }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end



  searchable do

    text :title, :description
    time :scheduled

    text :area_title do
      self.position.area.title
    end

    integer :area_id do
      self.position.area.id
    end

    text :holder_name do
      self.position.holder.full_name
    end

    integer :holder_id do
      p self.position.holder.id.to_s
      self.position.holder.id
    end

    text :holder_position do
      self.position.title
    end

    text :attendee_name do
      [self.attendees.map{|attendee| attendee.name },self.attendees.map{|attendee| attendee.company}]
    end

  end

end
