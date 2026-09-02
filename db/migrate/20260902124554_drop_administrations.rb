class DropAdministrations < ActiveRecord::Migration[8.1]
  def up
    drop_table :administrations
  end

  def down
    create_table :administrations do |t|
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
