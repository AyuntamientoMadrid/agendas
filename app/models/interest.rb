class Interest < ActiveRecord::Base

  has_many :organization_interests
  has_many :organizations, through: :organization_interest

end
