class MakeClaimOptionalOnChats < ActiveRecord::Migration[8.1]
  def change
    change_column_null :chats, :claim_id, true
  end
end
