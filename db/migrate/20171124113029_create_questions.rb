class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :answer
      t.integer :position, default: 1

      t.timestamps null: false
    end
  end
end
