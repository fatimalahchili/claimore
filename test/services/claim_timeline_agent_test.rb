require "test_helper"

class ClaimTimelineAgentTest < ActiveSupport::TestCase
  FakeChat = Struct.new(:claim, :instructions, :tools, :asked_content) do
    def with_runtime_instructions(value)
      self.instructions = value
      self
    end

    def with_tools(*values)
      self.tools = values
      self
    end

    def ask(content)
      self.asked_content = content
      :response
    end
  end

  test "configures claim-scoped RubyLLM tools before asking" do
    property = Property.create!(address: "123 Main Street", moved_on: Date.current)
    claim = Claim.create!(property: property, category: "Heating", status: "active")
    chat = FakeChat.new(claim)

    result = ClaimTimelineAgent.new(chat).ask("Record my call")

    assert_equal :response, result
    assert_includes chat.instructions, "explicitly asks"
    assert_equal [GetClaimContextTool, CreateClaimEntryTool], chat.tools.map(&:class)
    assert_equal "Record my call", chat.asked_content
  end
end
