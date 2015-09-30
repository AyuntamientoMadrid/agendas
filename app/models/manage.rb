class Manage < ActiveRecord::Base

  # Relations
  belongs_to :user
  belongs_to :holder

  # Validations
  validates_presence_of :user, :holder
  validates :holder, uniqueness: true

end
