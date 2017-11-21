class Area < ActiveRecord::Base

  has_ancestry

  validates_presence_of :title

  before_create :set_defaults
  after_save :update_children

  scope :active, -> { where(active: true) }

  def self.area_tree
    all.each { |c|
      c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
    }.sort {|x,y|
      x.ancestry <=> y.ancestry
    }.map{ |c|
      ["--"  * (c.depth - 1) + c.title,c.id]
    }
  end

  private

  def set_defaults
    self.active ||= true
  end

  def update_children
    children.update_all active: active unless active == active_was
  end

end
