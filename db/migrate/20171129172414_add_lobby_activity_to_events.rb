class AddLobbyActivityToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lobby_activity, :boolean , :default => false
  end
end
