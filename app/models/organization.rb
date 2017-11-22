class Organization < ActiveRecord::Base

  enum registered_lobbies: [:generalitat_catalunya, :cnmc, :europe_union, :others]
  enum range_fund: [:range_1, :range_2, :range_3, :range_4]
  enum entity_type: [:association, :federation, :lobby]

  validates_uniqueness_of :inscription_reference, allow_blank: true, allow_nil: true 

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
