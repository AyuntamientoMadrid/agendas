class Holder < ActiveRecord::Base

  # Relations
  has_many :manages
  has_many :users, through: :manages

  has_many :positions

  def full_name
    self.first_name.to_s+' '+self.last_name.to_s
  end

end
