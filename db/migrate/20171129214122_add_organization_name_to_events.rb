class AddOrganizationNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :organization_name, :string
  end
end
