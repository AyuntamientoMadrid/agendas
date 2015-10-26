class AddUserKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_key, :string
  end
end
