class RemoveAcceptedReasonFieldFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :accepted_reasons
  end
end
