class AddLobbyScheduledToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lobby_scheduled, :text
  end
end
