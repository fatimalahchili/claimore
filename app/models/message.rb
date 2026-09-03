class Message < ApplicationRecord
  acts_as_message
  has_many_attached :attachments

  scope :visible_to_user, -> { where.not(role: "system") }

  after_create_commit -> { broadcast_append_later_to "chat_#{chat_id}", target: "messages" }, if: :visible_to_user?
  # An assistant message's content only ever gets updated once it's fully
  # generated (either by ruby_llm's own completion save, or by our canonical-
  # refusal override in ChatResponseJob) — never mid-stream, since streaming
  # chunks are appended directly via broadcast_append_chunk, not through an
  # AR update. So any update reaching this point represents settled, final
  # content: mark it as such so the markdown controller freezes against any
  # later stray append (see markdown_controller.js).
  after_update_commit -> {
    broadcast_replace_later_to "chat_#{chat_id}", partial: "messages/message", locals: { message: self, final: true }
  }, if: :visible_to_user?
  after_destroy_commit -> { broadcast_remove_to "chat_#{chat_id}" }

  def visible_to_user?
    role.to_s != "system"
  end

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
                        target: "message_#{id}_content",
                        content: ERB::Util.html_escape(content.to_s)
  end
end
