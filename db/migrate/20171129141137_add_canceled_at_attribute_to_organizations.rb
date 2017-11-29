class AddCanceledAtAttributeToOrganizations < ActiveRecord::Migration
  def up
    change_table :organizations do |t|
      t.datetime :canceled_at
    end
  end

  def down
    change_table :organizations do |t|
      t.remove :canceled_at
    end
  end
end
