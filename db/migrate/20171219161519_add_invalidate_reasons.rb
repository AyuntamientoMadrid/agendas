class AddInvalidateReasons < ActiveRecord::Migration
  def up
    rename_column :events, :reasons, :canceled_reasons
    add_column :organizations, :invalidated_reasons, :string
    execute "ALTER TABLE organizations ALTER COLUMN invalidate TYPE timestamp USING  date '1970-01-01'"
    rename_column :organizations, :invalidate, :invalidated_at
  end

  def down
    rename_column :events, :canceled_reasons, :reasons
    remove_column :organizations, :invalidated_reasons
    change_column :organizations, :invalidate, :boolean
    rename_column :organizations, :invalidated_at, :invalidate
  end
end
