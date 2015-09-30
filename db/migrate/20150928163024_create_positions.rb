class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :title
      t.datetime :from
      t.datetime :to
      t.references :area, index: true, foreign_key: true
      t.references :holder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
