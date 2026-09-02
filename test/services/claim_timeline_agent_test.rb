require "test_helper"

class ClaimTimelineAgentTest < ActiveSupport::TestCase
  FakeChat = Struct.new(:claim, :instructions, :tools, :asked_content, :thinking, :params) do
    def with_thinking(effort:)
      self.thinking = effort
      self
    end

    def with_params(**values)
      self.params = values
      self
    end

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
    expected_tools = [GetClaimContextTool, CreateClaimEntryTool, UpdateClaimEntryTool, GetTemplatesTool,
                      DraftLetterTool, GetRelevantLawTextsTool]
    assert_equal expected_tools, chat.tools.map(&:class)
    assert_includes chat.instructions, "never create a new entry when the user asked to edit one"
    assert_equal "Record my call", chat.asked_content
    assert_equal :minimal, chat.thinking
    assert_equal({ max_completion_tokens: 400 }, chat.params)
  end

  test "supports global chats without exposing claim tools" do
    chat = FakeChat.new(nil)

    result = ClaimTimelineAgent.new(chat).ask("How can you help me?")

    assert_equal :response, result
    assert_includes chat.instructions, "housing matters"
    assert_equal [GetRelevantLawTextsTool], chat.tools.map(&:class)
    assert_equal "How can you help me?", chat.asked_content
  end
end
