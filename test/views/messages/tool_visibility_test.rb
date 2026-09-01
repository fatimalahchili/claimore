require "test_helper"

class MessagesToolVisibilityTest < ActionView::TestCase
  test "claim context tool call hides raw arguments" do
    tool_calls = Struct.new(:id).new(1)
    tool_call = Struct.new(:arguments).new({ claim_id: 42, private_context: "debug details" })

    render partial: "messages/tool_calls/get_claim_context",
           locals: { tool_calls: tool_calls, tool_call: tool_call }

    assert_includes rendered, "Checking claim timeline"
    assert_not_includes rendered, "private_context"
    assert_not_includes rendered, "debug details"
  end

  test "claim context tool result hides raw output" do
    tool = Struct.new(:id, :content, :tool_error_message).new(
      2,
      "full internal claim context",
      nil
    )

    render partial: "messages/tool_results/get_claim_context", locals: { tool: tool }

    assert_includes rendered, "Claim timeline checked"
    assert_not_includes rendered, "full internal claim context"
  end
end
