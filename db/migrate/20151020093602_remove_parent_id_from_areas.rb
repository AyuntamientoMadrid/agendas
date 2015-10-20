class RemoveParentIdFromAreas < ActiveRecord::Migration
  def change
    remove_column :areas, :parent_id
  end
end
