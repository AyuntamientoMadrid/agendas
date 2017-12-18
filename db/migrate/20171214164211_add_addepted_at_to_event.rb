class AddAddeptedAtToEvent < ActiveRecord::Migration
  def change
    add_column :events, :accepted_at, :date
    add_column :events, :accepted_reasons, :string
  end
end
