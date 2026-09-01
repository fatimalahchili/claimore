require "test_helper"
require "ostruct"

class ChatResponseJobTest < ActiveJob::TestCase
  class FakeAgent
    attr_reader :chat

    def initialize(chat)
      @chat = chat
    end

    def ask(_content)
      chat.messages.create!(role: "assistant", content: "")
      yield OpenStruct.new(content: "**Hello")
      yield OpenStruct.new(content: "**\n\n- item")
    end
  end

  test "streams accumulated assistant chunks through markdown updates" do
    chat = Chat.create!(session_id: "test-session")
    updates = []
    original_broadcast_update_markdown = Message.instance_method(:broadcast_update_markdown)
    original_agent_new = ClaimTimelineAgent.method(:new)

    Message.define_method(:broadcast_update_markdown) do |content|
      updates << content
    end
    ClaimTimelineAgent.define_singleton_method(:new) { |_chat| FakeAgent.new(chat) }

    ChatResponseJob.perform_now(chat.id, "Hello")

    assert_equal ["**Hello", "**Hello**\n\n- item"], updates
  ensure
    Message.define_method(:broadcast_update_markdown, original_broadcast_update_markdown)
    ClaimTimelineAgent.define_singleton_method(:new, original_agent_new)
  end
end
