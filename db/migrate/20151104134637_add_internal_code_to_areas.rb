class AddInternalCodeToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :internal_code, :string
  end
end
