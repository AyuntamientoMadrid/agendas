class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :subject
      t.string :body
      t.datetime :sent_at, default: nil

      t.timestamps null: false
    end
  end
end
