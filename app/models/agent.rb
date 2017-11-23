class Agent < ActiveRecord::Base

  belongs_to :organization

  validates :name, :identifier, :from, presence: true

end
