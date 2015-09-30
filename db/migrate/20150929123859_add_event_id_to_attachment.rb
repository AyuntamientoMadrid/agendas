class AddEventIdToAttachment < ActiveRecord::Migration
  def change
    add_reference :attachments, :event, index: true, foreign_key: true
  end
end
