class CreateRegisteredLobbies < ActiveRecord::Migration
  def change
    create_table :registered_lobbies do |t|
      t.text :name

      t.timestamps null: false
    end
  end
end
