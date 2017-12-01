class CreateEventRepresentedEntities < ActiveRecord::Migration
  def change
    create_table :event_represented_entities do |t|
      t.references :event, index: true, foreign_key: true
      t.string :name
    end
  end
end
