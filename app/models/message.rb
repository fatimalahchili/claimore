class Message < ApplicationRecord
  MARKDOWN_ALLOWED_TAGS = %w[
    a blockquote br code em h1 h2 h3 h4 h5 h6 hr li ol p pre strong ul
  ].freeze
  MARKDOWN_ALLOWED_ATTRIBUTES = %w[href title].freeze

  acts_as_message
  has_many_attached :attachments

  broadcasts_to ->(message) { "chat_#{message.chat_id}" }, inserts_by: :append

  def self.render_markdown(content)
    html = Commonmarker.to_html(content.to_s, options: { render: { unsafe: false } })
    Rails::HTML5::SafeListSanitizer.new.sanitize(html, tags: MARKDOWN_ALLOWED_TAGS, attributes: MARKDOWN_ALLOWED_ATTRIBUTES)
  end

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
                        target: "message_#{id}_content",
                        content: ERB::Util.html_escape(content.to_s)
  end

  def broadcast_update_markdown(content)
    broadcast_update_to "chat_#{chat_id}",
                        target: "message_#{id}_content",
                        content: self.class.render_markdown(content)
  end
end
