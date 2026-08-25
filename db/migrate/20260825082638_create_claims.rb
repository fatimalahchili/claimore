class CreateClaims < ActiveRecord::Migration[8.1]
  def change
    create_table :claims do |t|
      t.string :category
      t.string :status

      t.timestamps
    end
  end
end
