class RenameFieldsFromOrganizations < ActiveRecord::Migration
  def change
    rename_column :organizations, :first_name, :first_surname
    rename_column :organizations, :last_name, :second_surname
  end
end
