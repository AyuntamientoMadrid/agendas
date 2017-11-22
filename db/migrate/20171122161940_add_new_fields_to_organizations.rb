class AddNewFieldsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :inscription_reference, :string
    add_column :organizations, :inscription_date, :date
    add_column :organizations, :entity_type, :string
    add_column :organizations, :neighbourhood, :string
    add_column :organizations, :district, :string
    add_column :organizations, :scope, :string
    add_column :organizations, :associations_count, :integer
    add_column :organizations, :members_count, :integer
  end
end
