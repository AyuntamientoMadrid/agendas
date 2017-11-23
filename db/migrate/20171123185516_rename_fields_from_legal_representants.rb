class RenameFieldsFromLegalRepresentants < ActiveRecord::Migration
  def change
    rename_column :legal_representants, :first_name, :first_surname
    rename_column :legal_representants, :last_name, :second_surname
  end
end
