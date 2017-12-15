class Position < ActiveRecord::Base

  belongs_to :area
  belongs_to :holder
  has_many :participants, dependent: :destroy
  has_many :titular_events, class_name: "Event", dependent: :destroy
  has_many :participants_events, through: :participants

  validates :title, :area, presence: true
  scope :current, -> { where(to: nil) }
  scope :previous, -> { where.not(to: nil) }
  scope :area_filtered, ->(area) { where(area_id: Area.find(area).subtree_ids) if area.present? }
  scope :full_like, lambda { |search_name| where("holder_id IN (?) OR title ILIKE ?", Holder.by_name(search_name).pluck(:id), "%#{search_name}%") }
  def events
    (titular_events + participants_events).uniq
  end

  def finalize
    self.to = Time.now
    self
  end

  def self.holders(user_id)
    holder_ids = Holder.managed_by(user_id).ids
    Position.where(holder_id: holder_ids)
  end

  def full_name
    holder = Holder.where(id: self.holder_id).first
    (holder.last_name.to_s.delete(',') + ', ' + holder.first_name.to_s.delete(',') + ' - ' + self.title).mb_chars.to_s
  end

end
