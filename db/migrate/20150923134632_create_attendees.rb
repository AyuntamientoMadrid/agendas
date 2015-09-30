class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :name
      t.string :position
      t.string :company

      t.timestamps null: false
    end
  end
end
