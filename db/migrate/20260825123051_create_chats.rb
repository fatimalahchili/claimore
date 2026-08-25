class CreateChats < ActiveRecord::Migration[8.1]
  def change
    create_table :chats do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :claim, null: false, foreign_key: true

      t.timestamps
    end
  end
end
