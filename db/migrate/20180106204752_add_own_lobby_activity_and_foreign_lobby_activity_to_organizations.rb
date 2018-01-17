class AddOwnLobbyActivityAndForeignLobbyActivityToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :own_lobby_activity, :boolean, default: false
    add_column :organizations, :foreign_lobby_activity, :boolean, default: false
  end
end
