class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :internal_id
      t.string :title
      t.integer :parent_id
      t.integer :active

      t.timestamps null: false
    end
  end
end
