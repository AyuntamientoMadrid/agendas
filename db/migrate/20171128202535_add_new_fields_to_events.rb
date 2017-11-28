class AddNewFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lobby_activity, :boolean
    add_column :events, :notes, :text
    add_column :events, :status, :integer
    add_column :events, :reasons, :string
    add_column :events, :published_at, :date
    add_column :events, :canceled_at, :date
  end
end
