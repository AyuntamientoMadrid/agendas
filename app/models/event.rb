class Event < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner: Proc.new { |controller, model| controller.present? ? controller.current_user : model.user }
  tracked title: Proc.new { |controller, model| controller.present? ? controller.get_title : model.title }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, :position, :scheduled, :location, :lobby_activity, :published_at, presence: true
  validates_inclusion_of :lobby_activity, :in => [true, false]
  validate :participants_uniqueness, :position_not_in_participants

  before_create :set_status

  belongs_to :user
  belongs_to :position
  has_many :participants, dependent: :destroy
  has_many :positions, through: :participants
  has_many :attachments, dependent: :destroy
  has_many :attendees, dependent: :destroy

  accepts_nested_attributes_for :attendees, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

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

  def self.searches(search_person, search_title)
    if search_person.present? || search_title.present?
      @events = by_holder_name(search_person).uniq if search_person.present?
      @events = by_title(search_title) if search_title.present?
    else
      @events = all
    end
    @events
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
      self.status = :on_request if self.user.lobby?
    end
end
