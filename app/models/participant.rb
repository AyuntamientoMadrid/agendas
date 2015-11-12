class Participant < ActiveRecord::Base

  # Relations
  belongs_to :position
  belongs_to :event

end
