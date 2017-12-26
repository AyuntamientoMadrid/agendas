class AddAllowPublicDataToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :allow_public_data, :boolean
  end
end
