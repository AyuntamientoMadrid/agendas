class EventAgent < ActiveRecord::Base

  belongs_to :event, dependent: :destroy

end
