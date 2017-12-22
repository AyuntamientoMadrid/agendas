class AddDefaultValueToSubventionAndContract < ActiveRecord::Migration
  def change
    change_column :organizations, :subvention, :boolean, default: false
    change_column :organizations, :contract, :boolean, default: false
  end
end
