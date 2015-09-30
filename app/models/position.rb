class Position < ActiveRecord::Base

  # Relations
  belongs_to :area
  belongs_to :holder
  has_many :participants, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :events, through: :participants, dependent: :destroy

  # Validations
  validates_presence_of :title, :area
  validate :date_to_before_date_from

  scope :current, -> { where(to: nil) }

  private

  def date_to_before_date_from
    errors.add(:to, "to can't be previous to from") if to.present? and from < to
  end



end
