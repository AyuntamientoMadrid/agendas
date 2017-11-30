class EventRepresentedEntity < ActiveRecord::Base

  belongs_to :event, dependent: :destroy

end
