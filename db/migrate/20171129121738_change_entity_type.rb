class ChangeEntityType < ActiveRecord::Migration
  def change
    change_column :organizations, :entity_type, 'integer USING CAST(entity_type AS integer)'

  end
end
