class Agent < ActiveRecord::Base

  belongs_to :organization

  validates :name, :identifier, :from, presence: true

  def fullname
    str = name
    str += ", #{first_surname} "  if first_surname.present?
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
