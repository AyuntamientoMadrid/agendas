class AddPhonesAndOrganizationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phones, :string
    add_reference :users, :organization, index: true, foreign_key: true
  end
end
