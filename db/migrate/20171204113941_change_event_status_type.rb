class ChangeEventStatusType < ActiveRecord::Migration
  def change
    change_column :events, :status, 'integer USING CAST(status AS integer)', default: 0
  end
end
