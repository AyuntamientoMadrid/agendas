class AddFieldsToLegalRepresentants < ActiveRecord::Migration
  def change
    add_column :legal_representants, :check_email, :boolean
    add_column :legal_representants, :check_sms, :boolean
  end
end
