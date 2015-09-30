class CreateManages < ActiveRecord::Migration
  def change
    create_table :manages do |t|
      t.references :user, index: true, foreign_key: true
      t.references :holder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
