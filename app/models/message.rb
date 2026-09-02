class Message < ApplicationRecord
  acts_as_message
  has_many_attached :attachments

  scope :visible_to_user, -> {
    where.not(role: %w[system tool])
      .left_joins(:tool_calls)
      .where(tool_calls: { id: nil })
  }

  after_create_commit -> { broadcast_append_later_to "chat_#{chat_id}", target: "messages" }, if: :visible_to_user?
  after_update_commit -> { broadcast_replace_later_to "chat_#{chat_id}" }, if: :visible_to_user?
  after_destroy_commit -> { broadcast_remove_to "chat_#{chat_id}" }

  def visible_to_user?
    !%w[system tool].include?(role) && !tool_calls.exists?
  end

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
                        target: "message_#{id}_content",
                        content: ERB::Util.html_escape(content.to_s)
  end
end
