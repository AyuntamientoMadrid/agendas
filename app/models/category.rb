class Category < ActiveRecord::Base

  has_many :organizations, dependent: :destroy

  scope :visible, -> { where(display: true) }

end
