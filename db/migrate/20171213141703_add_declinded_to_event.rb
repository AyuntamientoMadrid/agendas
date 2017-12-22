class AddDeclindedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :declined_at, :date
    add_column :events, :declined_reasons, :string
  end
end
