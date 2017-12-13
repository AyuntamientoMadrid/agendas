class AddLobbyContactFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lobby_contact_firstname, :string
    add_column :events, :lobby_contact_lastname, :string
    add_column :events, :lobby_contact_email, :string
    add_column :events, :lobby_contact_phone, :string
  end
end
