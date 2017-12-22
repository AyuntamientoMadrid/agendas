class RemoveOrganizationReferenceFromRegisteredLobbies < ActiveRecord::Migration
  def change
    remove_reference(:registered_lobbies, :organization, index: true, foreign_key: true)
  end
end
