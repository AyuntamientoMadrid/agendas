class EventRepresentedEntity < ActiveRecord::Base

  belongs_to :event, dependent: :destroy

  validates :name, presence: true

end
