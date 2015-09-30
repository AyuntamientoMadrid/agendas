class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :position, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
