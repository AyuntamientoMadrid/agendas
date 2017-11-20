class Organization < ActiveRecord::Base

  has_many :represented_entities
  has_many :agents
  has_many :organization_interests
  has_many :interests, through: :organization_interests
  has_many :subventions
  has_many :contracts
  has_many :funds
  has_one :comunication_representant
  has_one :user
  has_one :legal_representant
  belongs_to :category

end
