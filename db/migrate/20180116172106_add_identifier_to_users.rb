class AddIdentifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :identifier, :string
  end
end
