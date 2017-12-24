class ChangeInscriptionDateFormatFromOrganizations < ActiveRecord::Migration
  def change
    change_column :organizations, :inscription_date, :datetime
  end
end
