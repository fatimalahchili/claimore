class MakeChatUserOptionalAddSessionId < ActiveRecord::Migration[8.1]
  def change
    change_column_null :chats, :user_id, true
    add_column :chats, :session_id, :string
    add_index :chats, :session_id
  end
end
