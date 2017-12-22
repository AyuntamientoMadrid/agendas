class AddOrganizationsToRegisteredLobby < ActiveRecord::Migration
  def change
    add_reference :registered_lobbies, :organization, index: true, foreign_key: true
  end
end
