class ChangeAndAddFieldsToOrganizations < ActiveRecord::Migration
  def change
    rename_column :organizations, :denied_public_data, :certain_term
    rename_column :organizations, :denied_public_events, :code_of_conduct_term
    add_column :organizations, :gift_term, :boolean
    add_column :organizations, :lobby_term, :boolean
  end
end
