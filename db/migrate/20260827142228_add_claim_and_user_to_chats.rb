class AddClaimAndUserToChats < ActiveRecord::Migration[8.1]
  def change
    add_reference :chats, :claim, null: false, foreign_key: true
    add_reference :chats, :user, null: false, foreign_key: true
  end
end
