require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "visible_to_user hides system messages" do
    chat = Chat.create!(session_id: "test-session")
    user_message = chat.messages.create!(role: "user", content: "Hello")
    system_message = chat.messages.create!(role: "system", content: "Hidden instructions")
    assistant_message = chat.messages.create!(role: "assistant", content: "Hi there")

    assert_includes Message.visible_to_user, user_message
    assert_includes Message.visible_to_user, assistant_message
    assert_not_includes Message.visible_to_user, system_message
  end
end
