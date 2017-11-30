class Organization < ActiveRecord::Base

  enum registered_lobbies: [:no_record, :generalitat_catalunya, :cnmc, :europe_union, :others]
  enum range_fund: [:range_1, :range_2, :range_3, :range_4]
  enum entity_type: [:association, :federation, :lobby]

  validates :inscription_reference, uniqueness: true, allow_blank: true, allow_nil: true
  validates :name, :user, :category_id, presence: true

  has_many :represented_entities, dependent: :destroy
  has_many :agents, dependent: :destroy
  has_many :organization_interests, dependent: :destroy
  has_many :interests, through: :organization_interests, dependent: :destroy
  has_many :subventions, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :funds, dependent: :destroy
  has_one :comunication_representant, dependent: :destroy
  has_one :user, dependent: :destroy
  has_one :legal_representant, dependent: :destroy
  belongs_to :category

  accepts_nested_attributes_for :legal_representant, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :represented_entities, allow_destroy: true
  accepts_nested_attributes_for :agents, allow_destroy: true

  after_create :set_inscription_date

  searchable do
    text :name, :first_surname, :second_surname, :description
    time :created_at
    boolean :invalidate
  end

  scope :invalidated, -> { where('invalidate = ?', true) }
  scope :validated, -> { where('invalidate = ?', false) }

  def fullname
    str = name
    str += " #{first_surname}"  if first_surname.present?
    str += " #{second_surname}" if second_surname.present?
    str
  end

  def legal_representant_full_name
    legal_representant.fullname if legal_representant
  end

  def user_name
    user.full_name
  end

  def set_inscription_date
    self.inscription_date = Date.current if self.inscription_date.blank?
    self.save
  end

end
