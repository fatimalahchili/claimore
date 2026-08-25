class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :address
      t.date :moved_on

      t.timestamps
    end
  end
end
