class ChangeDescriptionDefault < ActiveRecord::Migration
  def change
    change_column_default(:organizations, :description, "")
  end
end
