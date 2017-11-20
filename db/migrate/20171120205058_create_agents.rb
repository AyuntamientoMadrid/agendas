class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :identifier
      t.string :name
      t.string :first_name
      t.string :last_name
      t.date :from
      t.date :to
      t.text :public_assignments
      t.references :organization, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
