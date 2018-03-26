class AddOtherRegisteredLobbyToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :other_registered_lobby, :string
  end
end
