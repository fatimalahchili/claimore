class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)
    chat.with_instructions(chat.system_instructions)

    response_content = +""

    ClaimTimelineAgent.new(chat).ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        response_content << chunk.content
        message = chat.messages.last
        message.broadcast_update_markdown(response_content.dup)
      end
    end
  end
end
