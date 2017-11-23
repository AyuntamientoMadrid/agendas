class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :reference
      t.string :identifier
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :address_type
      t.string :address
      t.string :number
      t.string :gateway
      t.string :stairs
      t.string :floor
      t.string :door
      t.string :postal_code
      t.string :town
      t.string :province
      t.string :phones
      t.string :email
      t.references :category, index: true, foreign_key: true
      t.string :description
      t.string :web
      t.integer :registered_lobbies
      t.integer :fiscal_year
      t.integer :range_funds
      t.boolean :subvention
      t.boolean :contract
      t.boolean :denied_public_data
      t.boolean :denied_public_events

      t.timestamps null: false
    end
  end
end
