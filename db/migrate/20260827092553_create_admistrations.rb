class CreateAdmistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :admistrations do |t|
      t.string :name
      t.string :role
      t.string :email
      t.text :address
      t.string :phone_number
      t.string :website

      t.timestamps
    end
  end
end
