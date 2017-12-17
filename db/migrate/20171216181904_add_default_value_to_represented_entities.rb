class AddDefaultValueToRepresentedEntities < ActiveRecord::Migration
  def change
    change_column :represented_entities, :subvention, :boolean, default: false
    change_column :represented_entities, :contract, :boolean, default: false
  end
end
