class AddFieldsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :number_type, :string
    add_column :organizations, :check_email, :boolean
    add_column :organizations, :check_sms, :boolean
  end
end
