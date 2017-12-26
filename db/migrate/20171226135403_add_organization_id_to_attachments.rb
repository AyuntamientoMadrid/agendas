class AddOrganizationIdToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :organization, index: true, foreign_key: true
  end
end
