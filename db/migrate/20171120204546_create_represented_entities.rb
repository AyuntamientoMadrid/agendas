class CreateRepresentedEntities < ActiveRecord::Migration
  def change
    create_table :represented_entities do |t|
      t.string :identifier
      t.string :name
      t.string :first_name
      t.string :last_name
      t.date :from
      t.date :to
      t.references :organization, index: true, foreign_key: true
      t.integer :fiscal_year
      t.integer :range_fund
      t.boolean :subvention
      t.boolean :contract       

      t.timestamps null: false
    end
  end
end
