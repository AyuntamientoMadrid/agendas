class CreateLog < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :organization_id
      t.string :action
      t.belongs_to :actionable, polymorphic: true
      t.timestamps
    end

    add_index :logs, [:actionable_id, :actionable_type]
    add_index :logs, :organization_id
  end
end
