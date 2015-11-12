class Manage < ActiveRecord::Base

  # Relations
  belongs_to :user
  belongs_to :holder

  # Validations
  validates_uniqueness_of :holder_id, scope: :user_id


end
