class Event < ActiveRecord::Base
  include PublicActivity::Model

  attr_accessor :cancel, :decline, :accept, :holder_title, :current_user

  tracked owner: Proc.new { |controller, model| controller.present? ? controller.current_user : model.user }
  tracked title: Proc.new { |controller, model| controller.present? ? controller.get_title : model.title }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates_with CancelEventValidator

  validates :title, :position, :location, presence: true
  validates_inclusion_of :lobby_activity, :in => [true, false]
  validate :participants_uniqueness, :position_not_in_participants, :role_validate_scheduled
  validates :reasons, presence: {message: I18n.t('backend.lobby_not_allowed_neither_empty_mail') }, if: Proc.new { |a| !a.canceled_at.blank? }
  validates :declined_reasons, presence: {message: I18n.t('backend.lobby_not_allowed_neither_empty_mail') }, if: Proc.new { |a| !a.declined_at.blank? || (a.current_user && !a.current_user.lobby?)}
  validates :accepted_reasons, presence: {message: I18n.t('backend.lobby_not_allowed_neither_empty_mail') }, if: Proc.new { |a| !a.accepted_at.blank? || (a.current_user && !a.current_user.lobby?)}

  before_create :set_status
  before_update :set_published_at
  after_validation :decline_event
  after_validation :cancel_event
  after_validation :accept_event

  belongs_to :user
  belongs_to :position
  belongs_to :organization
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

  SUPPORTED_FILTERS = [:title, :position_id, :lobby_activity, :status, :organization_id].freeze
  scope :title, lambda {|title| where("title ILIKE ?", "%#{title}%") }
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
  scope :status, ->(status) { where("status IN (#{status})") }
  scope :lobby_activity, ->(lobby_activity){ where(lobby_activity: lobby_activity) }
  scope :position_id, ->(position) { where(position_id: position) }
  scope :organization_id, ->(organization) { where(organization_id: organization) }
  scope :published, ->{ where("published_at <= ? AND status != ?", Time.zone.today, 4) }
  enum status: { requested: 0, accepted: 1, done: 2, declined: 3, canceled: 4 }

  def cancel_event
    return unless cancel == 'true' && canceled_at.nil? && status == 'accepted'
    self.canceled_at = Time.zone.today
    self.status = 'canceled'
    EventMailer.cancel(self).deliver_now
  end

  def decline_event
    return unless decline == 'true' && declined_at.nil?
    self.declined_at = Time.zone.today
    self.status = 'declined'
    EventMailer.decline(self).deliver_now
  end

  def accept_event
    return unless accept == 'true' && accepted_at.nil?
    self.accepted_at = Time.zone.today
    self.status = 'accepted'
    EventMailer.accept(self).deliver_now
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

  def self.searches(params)
    if params.present?
      events = filter(params)
    else
      events = all
    end
    events
  end

  searchable do
    text :title, :description
    time :scheduled
    boolean :lobby_activity
    date :published_at
    integer :organization_id

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

    integer :holder_id, multiple: true do
      self.participants.collect(&:position).collect(&:holder_id) << self.position.holder.id
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

  def self.filter(attributes)
    attributes.slice(*SUPPORTED_FILTERS).reduce(all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  def lobby_user_name
    "#{lobby_contact_firstname} #{lobby_contact_lastname}"
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
      if self.user.lobby?
        self.status = "requested"
      else
        self.status = "accepted"
      end
    end

    def set_published_at
      self.published_at = Date.current if (!self.user.lobby? && self.published_at.blank?)
    end

    def role_validate_scheduled
      return if self.user.lobby? || self.scheduled.present?
      errors.add(:base, "Fecha del evento no puede estar en blanco")
    end

end
