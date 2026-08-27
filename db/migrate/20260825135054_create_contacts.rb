class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.references :property, null: false, foreign_key: true
      t.string :name
      t.string :role
      t.string :email
      t.string :address
      t.string :phone_number
      t.string :website

      t.timestamps
    end
  end
end
