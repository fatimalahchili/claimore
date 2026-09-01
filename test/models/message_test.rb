require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "visible_to_user excludes system messages" do
    chat = Chat.create!(session_id: "test-session")
    system_message = chat.messages.create!(role: "system", content: "Private instructions")
    user_message = chat.messages.create!(role: "user", content: "Hello")

    assert_includes Message.visible_to_user, user_message
    assert_not_includes Message.visible_to_user, system_message
  end
end
