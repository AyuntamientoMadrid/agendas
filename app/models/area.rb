class Area < ActiveRecord::Base

  has_ancestry

  # Relations
  belongs_to :parent, class_name: "Area", foreign_key: "parent_id"
  has_many :children, class_name: "Area", foreign_key: "parent_id", dependent: :destroy

  # Validations
  validates_presence_of :title

  # Callbacks
  after_initialize :set_defaults
  after_save :update_children

  # Scopes
  #scope :main_areas, -> { where(parent_id: 0) }
  #scope :children_areas, -> { where.not(parent_id: 0) }
  #scope :filtered, lambda{ |parent| self.where(parent_id: parent) if parent.present? }

  private

  def set_defaults
    self.active ||= true
  end

  def update_children
    self.children.update_all active: self.active unless self.active == self.active_was
  end

end
