class CreateLetters < ActiveRecord::Migration[8.1]
  def change
    create_table :letters do |t|
      t.references :claim, null: false, foreign_key: true
      t.string :title
      t.text :summary
      t.date :sent_on

      t.timestamps
    end
  end
end
