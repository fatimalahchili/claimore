require "test_helper"

class GetRelevantLawTextsToolTest < ActiveSupport::TestCase
  CLOSE_VECTOR = Array.new(1536, 1.0).freeze
  FAR_VECTOR = Array.new(1536, -1.0).freeze
  FakeEmbedding = Struct.new(:vectors)

  test "returns law texts ordered by relevance to the embedded query" do
    original_embed = RubyLLM.method(:embed)

    RubyLLM.define_singleton_method(:embed) do |text|
      FakeEmbedding.new(text.include?("Nebenkosten") ? FAR_VECTOR : CLOSE_VECTOR)
    end

    LawText.create!(subtitle: "Mietrecht", paragraph_title: "§ 573 Kündigung",
                    content: "Kündigungsgründe des Vermieters.")
    LawText.create!(subtitle: "Mietrecht", paragraph_title: "§ 556 Nebenkosten",
                    content: "Vereinbarungen über Betriebskosten.")

    result = GetRelevantLawTextsTool.new.execute(query: "Kündigung durch den Vermieter")

    assert_equal ["§ 573 Kündigung", "§ 556 Nebenkosten"], result.pluck(:paragraph_title)
  ensure
    RubyLLM.define_singleton_method(:embed, original_embed)
  end
end
