class AddInvalidateToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :invalidate, :boolean
  end
end
