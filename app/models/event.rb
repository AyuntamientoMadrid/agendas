class Event < ActiveRecord::Base
  include PublicActivity::Model

  attr_accessor :organization_id
  attr_accessor :cancel

  tracked owner: Proc.new { |controller, model| controller.present? ? controller.current_user : model.user }
  tracked title: Proc.new { |controller, model| controller.present? ? controller.get_title : model.title }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, :position, :location, presence: true
  validates_inclusion_of :lobby_activity, :in => [true, false]
  validate :participants_uniqueness, :position_not_in_participants, :role_validate_published_at, :role_validate_scheduled

  before_create :set_status
  before_save :cancel_event

  belongs_to :user
  belongs_to :position
  has_many :participants, dependent: :destroy
  has_many :positions, through: :participants
  has_many :attachments, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :event_represented_entities, dependent: :destroy, inverse_of: :event
  has_many :event_agents, dependent: :destroy, inverse_of: :event

  accepts_nested_attributes_for :attendees, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :event_represented_entities, allow_destroy: true
  accepts_nested_attributes_for :event_agents, allow_destroy: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

  enum status: { requested: 0, accepted: 1, canceled: 4 }

  scope :by_title, lambda {|title| where("title ILIKE ?", "%#{title}%") }
  scope :by_holders, lambda {|holder_ids|
    joins(:position).where("positions.holder_id IN (?)", holder_ids)
  }
  scope :by_participant_holders, lambda {|holder_ids|
    joins(participants: :position).where("positions.holder_id IN (?)", holder_ids)
  }
  scope :by_holder_name, lambda {|name|
    holder_ids = Holder.by_name(name).pluck(:id)
    joins(:position).where("positions.holder_id IN (?)", holder_ids)
  }

  scope :with_lobby_activity_active, -> { where(lobby_activity: true) }
  scope :published, -> { where("published_at <= ? AND status != ?", Time.zone.today, 4) }

  def cancel_event
    return unless cancel == 'true' && canceled_at.nil?
    self.canceled_at = Time.zone.today
    self.status = 'canceled'
    EventMailer.cancel(self).deliver_now
  end

  def self.managed_by(user)
    holder_ids = Holder.managed_by(user.id).pluck(:id)
    titular_event_ids = Event.by_holders(holder_ids).pluck(:id)
    participant_event_ids = Event.by_participant_holders(holder_ids).pluck(:id)

    Event.where(id: (titular_event_ids + participant_event_ids).uniq)
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

  def self.searches(search_person, search_title, search_lobby_activity)
    if search_person.present? || search_title.present? || search_lobby_activity.present?
      @events = by_holder_name(search_person).uniq if search_person.present?
      @events = by_title(search_title) if search_title.present?
      @events = with_lobby_activity_active if search_lobby_activity
    else
      @events = all
    end
    @events
  end

  searchable do
    text :title, :description
    time :scheduled
    boolean :lobby_activity
    date :published_at

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
      [self.attendees.map{|attendee| attendee.name },
       self.attendees.map{|attendee| attendee.company}]
    end
  end

  private_class_method def self.ability(user, method)
    event_ids = []
    user.manages.includes(:holder).each do |manage|
      manage.holder.positions.each do |position|
        event_ids += position.send(method).ids
      end
    end
    return event_ids
  end

  def position_names
    names = ''
    positions.each do |position|
      names += position.holder.full_name_comma + ' - ' + position.title
      names += ' / ' unless position == positions.last
    end
    return names
  end

  def user_name
    user.full_name
  end

  private

    def participants_uniqueness
      participants = self.participants.reject(&:marked_for_destruction?)
      return unless participants.map(&:position_id).uniq.count != participants.to_a.count
      errors.add(:base, I18n.t('backend.participants_uniqueness'))
    end

    def position_not_in_participants
      participants = self.participants.reject(&:marked_for_destruction?)
      positions_ids = participants.collect{|p| p.position.id }
      return unless position && positions_ids.include?(position.id)
      errors.add(:base, I18n.t('backend.position_not_in_participants'))
    end

    def set_status
      self.status = "requested" if self.user.lobby?
    end

    def role_validate_published_at
      return if self.user.lobby? || self.published_at.present?
      errors.add(:base, "Fecha de publicación no puede estar en blanco")
    end

    def role_validate_scheduled
      return if self.user.lobby? || self.scheduled.present?
      errors.add(:base, "Fecha del evento no puede estar en blanco")
    end
end
