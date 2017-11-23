class RenameFieldsFromAgents < ActiveRecord::Migration
  def change
    rename_column :agents, :first_name, :first_surname
    rename_column :agents, :last_name, :second_surname
  end
end
