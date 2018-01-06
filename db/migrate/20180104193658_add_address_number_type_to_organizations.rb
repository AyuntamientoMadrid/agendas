class AddAddressNumberTypeToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :address_number_type, :string
  end
end
