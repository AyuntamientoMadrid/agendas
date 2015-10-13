class Holder < ActiveRecord::Base

  # Relations
  has_many :manages
  has_many :users, through: :manages

  has_many :positions

  accepts_nested_attributes_for :positions, reject_if: :all_blank, allow_destroy: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    self.first_name.to_s+' '+self.last_name.to_s
  end

  def full_name_comma
    self.last_name.to_s+', '+self.first_name.to_s
  end
end
