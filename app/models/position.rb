class Position < ActiveRecord::Base

  # Relations
  belongs_to :area
  belongs_to :holder
  has_many :participants, dependent: :destroy
  has_many :titular_events, class_name: "Event", dependent: :destroy
  has_many :participants_events, through: :participants

  # Validations
  validates_presence_of :title, :area, :from
  validate :date_to_before_date_from

  scope :current, -> { where(to: nil) }
  scope :previous, -> { where(to: 'IS NOT NULL') }
  scope :area_filtered, lambda{ |area| self.where(area_id: [area, Area.find(area).descendant_ids]) if area.present? }

  def events
    (titular_events + participants_events).uniq
  end

  def finalize
    self.to = Time.now
    self
  end

  def self.holders(user_id)
    holder_ids = Holder.by_manages(user_id).ids
    Position.where(holder_id: holder_ids)
  end

  private

  def date_to_before_date_from
    errors.add(:to, "to can't be previous to from") if (to.present? && from > to)
  end

end
