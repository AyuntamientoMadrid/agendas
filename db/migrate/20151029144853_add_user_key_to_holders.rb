class AddUserKeyToHolders < ActiveRecord::Migration
  def change
    add_column :holders, :user_key, :string
  end
end
