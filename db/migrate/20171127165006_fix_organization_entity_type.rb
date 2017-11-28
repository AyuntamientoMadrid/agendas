class FixOrganizationEntityType < ActiveRecord::Migration
  def change
    #wtf, change column does not work
    remove_column :organizations, :entity_type
    add_column :organizations, :entity_type, :integer
  end
end
