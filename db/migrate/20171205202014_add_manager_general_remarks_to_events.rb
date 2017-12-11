class AddManagerGeneralRemarksToEvents < ActiveRecord::Migration
  def change
    add_column :events, :manager_general_remarks, :text
  end
end
