class AddDeletedAtAttributeToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.datetime :deleted_at
    end
  end

  def down
    change_table :users do |t|
      t.remove :deleted_at
    end
  end
end
