class AddClaimToLetters < ActiveRecord::Migration[8.1]
  def change
    add_reference :letters, :claim, null: false, foreign_key: true
  end
end
