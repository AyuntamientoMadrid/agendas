class Event < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner: Proc.new { |controller, model| controller && controller.current_user }
  tracked title: Proc.new { |controller, model| controller && controller.get_title }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  # Relations
  belongs_to :user
  belongs_to :position
  has_many :participants, dependent: :destroy
  has_many :positions, through: :participants
  has_many :attachments, dependent: :destroy
  has_many :attendees, dependent: :destroy

  # Validations
  validates_presence_of :title, :position, :scheduled
  #validate :participants_uniqueness
  validate :participants_uniqueness, :position_not_in_participants
  scope :by_title, lambda {|name| where(["title ILIKE ?", "%#{name}%"])}

  # Nested models
  accepts_nested_attributes_for :attendees, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :participants, :reject_if => :all_blank, :allow_destroy => true

  def participants_uniqueness
    participants = self.participants.reject(&:marked_for_destruction?)
    errors.add(:base, I18n.t('backend.participants_uniqueness')) unless participants.map{|x| x.position_id}.uniq.count == participants.to_a.count
  end

  def position_not_in_participants
    participants = self.participants.reject(&:marked_for_destruction?).map{|x| x.position_id}
    errors.add(:base, I18n.t('backend.position_not_in_participants')) if participants.include? position.id
  end

  def self.ability_events(user)
    event_ids = []
    event_ids += ability(user, 'titular_events')
    event_ids += ability(user, 'participants_events')
    return event_ids
  end

  def self.ability_titular_events(user)
    ability(user, 'titular_events')
  end

  def self.ability_participants_events(user)
    ability(user, 'participants_events')
  end

  def self.ability(user, method)
    event_ids = []
    user.manages.includes(:holder).each do |m|
      m.holder.positions.each do |p|
        event_ids += p.send(method).ids
      end
    end
    return event_ids
  end

  def self.searches(params)
    if params[:search_person].present? || params[:search_title].present?
      if params[:search_person].present?
        @events = Event.search_by_holder_name(params[:search_person]).uniq
      end
      if params[:search_title].present?
        @events = Event.by_title(params[:search_title])
      end
    else
      @events = Event.page(params[:page]).per(20)
    end

    return @events
  end

  def self.search_by_holder_name(name)
    holder_ids = Holder.by_name(name).pluck(:id)
    position_ids = Position.where(holder_id: holder_ids).pluck(:id)
    titular_event_ids = Event.where(position_id: position_ids).pluck(:id)
    participant_event_ids = Participant.where(position_id: position_ids).pluck(:event_id)

    @events = Event.where(id: (titular_event_ids + participant_event_ids).uniq).includes(:position, :attachments, position: [:holder])
  end

  def self.has_manage_holders(user_id)
    holder_ids = Holder.by_manages(user_id).pluck(:id)
    return true unless holder_ids.blank?
    false
  end

  def self.by_manages(user_id)
    holder_ids = Holder.by_manages(user_id).pluck(:id)
    position_ids = Position.where(holder_id: holder_ids).pluck(:id)
    titular_event_ids = Event.where(position_id: position_ids).pluck(:id)
    participant_event_ids = Participant.where(position_id: position_ids).pluck(:event_id)

    Event.where(id: (titular_event_ids + participant_event_ids).uniq).includes(:position, :attachments, position: [:holder])
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

    text :holder_first_name do
      self.position.holder.first_name
    end

    text :holder_last_name do
      self.position.holder.last_name
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
