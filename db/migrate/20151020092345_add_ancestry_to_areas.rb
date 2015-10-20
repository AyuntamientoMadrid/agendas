class AddAncestryToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :ancestry, :string
    add_index :areas, :ancestry
  end
end
