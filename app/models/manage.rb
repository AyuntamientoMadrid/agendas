class Manage < ActiveRecord::Base

  # Relations
  belongs_to :user
  belongs_to :holder

  # Validations
  validates :user, presence: true
  validates :holder, presence: true
  validates_uniqueness_of :holder_id, scope: :user_id


end
