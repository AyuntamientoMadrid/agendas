class Agent < ActiveRecord::Base

  belongs_to :organization
  has_one :attachment
  validates :name, :identifier, :from, presence: true
  validates  :attachment, presence: true
  validates_inclusion_of :allow_public_data, :in => [true, false]
  accepts_nested_attributes_for :attachment, reject_if: :all_blank, allow_destroy: true
  def fullname
    str = name
    str += ", #{first_surname}"  if first_surname.present?
    str += ", #{second_surname}" if second_surname.present?
    str
  end

  scope :by_organization, ->(organization_id) { where(organization_id: organization_id) }
  scope :from_active_organizations, -> { joins(:organization).where('canceled_at is NULL AND invalidate is FALSE') }

  searchable do
    text :name, :first_surname, :second_surname
    integer :organization_id
  end

end
