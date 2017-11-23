class RenameFieldsFromLegalRepresentedEntities < ActiveRecord::Migration
  def change
    rename_column :represented_entities, :first_name, :first_surname
    rename_column :represented_entities, :last_name, :second_surname
  end
end
