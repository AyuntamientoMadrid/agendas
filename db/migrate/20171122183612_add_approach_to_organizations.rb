class AddApproachToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :approach, :string
  end
end
