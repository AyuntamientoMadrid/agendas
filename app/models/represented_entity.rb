class RepresentedEntity < ActiveRecord::Base

  enum range_funds: [:range_1, :range_2, :range_3, :range_4]

  belongs_to :organization

end
