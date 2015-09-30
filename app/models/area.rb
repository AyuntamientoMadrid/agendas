class Area < ActiveRecord::Base

  # Relations
  belongs_to :parent, class_name: "Area", foreign_key: "parent_id"
  has_many :children, class_name: "Area", foreign_key: "parent_id", dependent: :destroy

  # Validations
  validates_presence_of :title

  # Callbacks
  after_initialize :set_defaults
  after_save :update_children


  scope :main_areas, -> { where(parent_id: 0) }
  scope :children_areas, -> { where.not(parent_id: 0) }

  private

  def set_defaults
    self.active ||= true
  end

  def update_children
    self.children.update_all active: self.active unless self.active == self.active_was
  end

end
