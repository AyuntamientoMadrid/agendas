class AddGeneralRemarksToEvents < ActiveRecord::Migration
  def change
    add_column :events, :general_remarks, :text
  end
end
