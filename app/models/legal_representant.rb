class LegalRepresentant < ActiveRecord::Base

  belongs_to :organization

  validates :identifier, :name, :first_surname, :email, presence: true

end
