class LegalRepresentant < ActiveRecord::Base

  belongs_to :organization

  validates :identifier, :name, :first_surname, :email, presence: true

  def fullname
    str = name
    str += " #{first_surname}"  if first_surname.present?
    str += " #{second_surname}" if second_surname.present?
    str
  end

end
