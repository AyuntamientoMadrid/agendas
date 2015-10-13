class Event < ActiveRecord::Base

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
  accepts_nested_attributes_for :attendees


  searchable do

    text :title, :description
    time :scheduled

    text :area_title do
      self.position.area.title
    end

    text :holder_name do
      self.position.holder.full_name
    end

    integer :holder_id do
      self.position.holder.id
    end

    integer :area_id do
      self.position.area.id
    end

    text :attendee_name do
      [self.attendees.map{|attendee| attendee.name },self.attendees.map{|attendee| attendee.company}]
    end

  end

end
