class Agent < ActiveRecord::Base

  belongs_to :organization
  has_many :attachments, dependent: :destroy

  validates :name, :from, presence: true
  validates :allow_public_data, inclusion: [true, false]

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def fullname
    str = name
    str += " #{first_surname}"  if first_surname.present?
    str += " #{second_surname}" if second_surname.present?
    str
  end

  scope :by_organization, ->(organization_id) { where(organization_id: organization_id) }
  scope :from_active_organizations, -> { joins(:organization).where('canceled_at is NULL AND invalidated_at is NULL') }
  scope :active, -> { where("agents.to is NULL OR agents.to >= ?", Date.current) }

  searchable do
    text :name, :first_surname, :second_surname
    integer :organization_id
  end

end
