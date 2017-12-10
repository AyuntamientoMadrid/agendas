class AddDisplayFieldToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :display, :boolean
  end
end
