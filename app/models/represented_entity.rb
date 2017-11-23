class RepresentedEntity < ActiveRecord::Base

  enum range_fund: [:range_1, :range_2, :range_3, :range_4]

  belongs_to :organization

  validates_presence_of :identifier, :name, :fiscal_year, :from

end
