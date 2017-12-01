class CreateEventAgents < ActiveRecord::Migration
  def change
    create_table :event_agents do |t|
      t.references :event, index: true, foreign_key: true
      t.string :name
    end
  end
end
