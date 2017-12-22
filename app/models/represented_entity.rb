class RepresentedEntity < ActiveRecord::Base

  enum range_fund: [:range_1, :range_2, :range_3, :range_4]

  belongs_to :organization

  validates :identifier, :name, :from, presence: true

  def fullname
    str = name
    str += " #{first_surname}"  if first_surname.present?
    str += " #{second_surname}" if second_surname.present?
    str
  end

  scope :by_organization, -> (organization_id) { where(organization_id: organization_id) }

end
