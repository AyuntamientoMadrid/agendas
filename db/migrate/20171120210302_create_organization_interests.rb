class CreateOrganizationInterests < ActiveRecord::Migration
  def change
    create_table :organization_interests do |t|
      t.references :organization, index: true, foreign_key: true
      t.references :interest, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
