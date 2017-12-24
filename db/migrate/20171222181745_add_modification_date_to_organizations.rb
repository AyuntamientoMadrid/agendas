class AddModificationDateToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :modification_date, :Date
  end
end
