class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :scheduled
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
