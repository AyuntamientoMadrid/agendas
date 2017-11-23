class Agent < ActiveRecord::Base

  belongs_to :organization

  validates_presence_of :name, :identifier, :from

end
