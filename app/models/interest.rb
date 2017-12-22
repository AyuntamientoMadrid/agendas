class Interest < ActiveRecord::Base

  has_many :organization_interests, dependent: :destroy
  has_many :organizations, through: :organization_interest

  searchable do
    integer :id, multiple: true
  end

end
