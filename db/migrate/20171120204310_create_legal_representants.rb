class CreateLegalRepresentants < ActiveRecord::Migration
  def change
    create_table :legal_representants do |t|
      t.string :identifier
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :phones
      t.string :email
      t.references :organization, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
