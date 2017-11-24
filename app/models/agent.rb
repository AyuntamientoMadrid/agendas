class Agent < ActiveRecord::Base

  belongs_to :organization

  validates :name, :identifier, :from, presence: true

  def fullname
    str = name
    str += " #{first_surname}"  if first_surname.present?
    str += " #{second_surname}" if second_surname.present?
    str
  end

end
