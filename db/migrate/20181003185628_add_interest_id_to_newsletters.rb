class AddInterestIdToNewsletters < ActiveRecord::Migration
  def change
    add_reference :newsletters, :interest, index: true, foreign_key: true, null: false
  end
end
