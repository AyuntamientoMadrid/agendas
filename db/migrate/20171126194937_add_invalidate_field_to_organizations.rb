class AddInvalidateFieldToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :invalidate, :boolean, default: false
  end
end
