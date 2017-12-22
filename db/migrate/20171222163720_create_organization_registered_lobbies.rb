class CreateOrganizationRegisteredLobbies < ActiveRecord::Migration
  def change
    create_table :organization_registered_lobbies do |t|
      t.references :organization, index: true, foreign_key: true
      t.references :registered_lobby, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
