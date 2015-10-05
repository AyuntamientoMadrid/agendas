class Manage < ActiveRecord::Base

  # Relations
  belongs_to :user
  belongs_to :holder

  # Validations
  validates :user, presence: true
  validates :holder, presence: true
  validates :holder, uniqueness: true

end
