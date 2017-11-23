class LegalRepresentant < ActiveRecord::Base

  belongs_to :organization

  validates_presence_of :identifier, :name, :first_surname, :email

end
