class AddFieldsToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :description, :text
    add_column :attachments, :public, :boolean
  end
end
