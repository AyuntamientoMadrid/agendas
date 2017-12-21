class AddAttachmentRefToAgent < ActiveRecord::Migration
  def change
    add_reference :attachments,:agent, index: true

  end
end
