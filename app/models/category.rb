class Category < ActiveRecord::Base

  has_many :organizations, dependent: :destroy

end
