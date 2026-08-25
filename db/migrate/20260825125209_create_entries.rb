class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.date :date
      t.string :title
      t.string :description
      t.string :category
      t.string :status
      t.references :claim, null: false, foreign_key: true

      t.timestamps
    end
  end
end
