class Event < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner: Proc.new { |controller, model| controller.current_user }
  tracked title: Proc.new { |controller, model| controller.get_title }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  belongs_to :user
  belongs_to :position
  has_many :participants, dependent: :destroy
  has_many :positions, through: :participants
  has_many :attachments, dependent: :destroy
  has_many :attendees, dependent: :destroy

  validates_presence_of :title, :position, :scheduled
  validate :participants_uniqueness, :position_not_in_participants
  scope :by_title, lambda {|title| where("title ILIKE ?", "%#{title}%")}

  accepts_nested_attributes_for :attendees, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

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
      @events = search_by_holder_name(search_person).uniq if search_person.present?
      @events = by_title(search_title) if search_title.present?
    else
      @events = all
    end
    @events
  end

  def self.managed_by(user_id)
    holder_ids = Holder.managed_by(user_id).pluck(:id)
    position_ids = Position.where(holder_id: holder_ids).pluck(:id)
    titular_event_ids = Event.where(position_id: position_ids).pluck(:id)
    participant_event_ids = Participant.where(position_id: position_ids)
                                       .pluck(:event_id)

    Event.where(id: (titular_event_ids + participant_event_ids).uniq)
         .includes(:position, :attachments, position: [:holder])
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

  private_class_method def self.search_by_holder_name(name)
    holder_ids = Holder.by_name(name).pluck(:id)
    position_ids = Position.where(holder_id: holder_ids).pluck(:id)
    titular_event_ids = Event.where(position_id: position_ids).pluck(:id)
    participant_event_ids = Participant.where(position_id: position_ids)
                                       .pluck(:event_id)

    Event.where(id: (titular_event_ids + participant_event_ids).uniq)
         .includes(:position, :attachments, position: [:holder])
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
end
