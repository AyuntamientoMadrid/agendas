class AddFileToAttachments < ActiveRecord::Migration

  def up
    add_attachment :attachments, :file
  end

  def down
    remove_attachment :attachments, :file
  end

end
