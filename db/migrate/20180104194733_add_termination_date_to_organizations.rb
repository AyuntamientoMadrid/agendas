class AddTerminationDateToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :termination_date, :date
  end
end
