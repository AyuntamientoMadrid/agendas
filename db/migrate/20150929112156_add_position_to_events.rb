class AddPositionToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :position, index: true, foreign_key: true
  end
end
