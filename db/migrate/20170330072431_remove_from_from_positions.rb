class RemoveFromFromPositions < ActiveRecord::Migration
  def change
    remove_column :positions, :from, :DATETIME
  end
end
