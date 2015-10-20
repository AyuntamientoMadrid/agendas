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


  def self.as_csv
    CSV.generate do |csv|
      csv << ["Title", "Description", "Location","Holder","Date"]
      all.each do |item|
        csv << [item.title, item.description, item.location, item.position.holder.full_name_comma, item.scheduled.strftime("%d/%m/%Y %H:%M")]
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

    integer :area_root_id do
      self.position.area.root.id
    end

    text :holder_name do
      self.position.holder.full_name
    end

    integer :holder_id do
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
