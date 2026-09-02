require "test_helper"

class DeleteClaimEntryToolTest < ActiveSupport::TestCase
  setup do
    property = Property.create!(address: "123 Main Street", moved_on: Date.current)
    @claim = Claim.create!(property: property, category: "Heating", status: "active")
    @entry = @claim.entries.create!(title: "Called landlord", description: "Reported issue", date: Date.new(2026, 8, 30))
    @tool = DeleteClaimEntryTool.new(@claim)
  end

  test "deletes an existing entry" do
    assert_difference -> { @claim.entries.count }, -1 do
      result = @tool.execute(entry_id: @entry.id)

      assert result[:success]
      assert_equal @entry.id, result[:entry_id]
    end

    assert_not Entry.exists?(@entry.id)
  end

  test "cannot delete an entry belonging to another claim" do
    other_claim = Claim.create!(property: @claim.property, category: "Plumbing", status: "active")
    other_entry = other_claim.entries.create!(title: "Other event")

    assert_no_difference -> { Entry.count } do
      result = @tool.execute(entry_id: other_entry.id)

      assert_not result[:success]
      assert_equal "Timeline entry was not found on this claim", result[:error]
    end
  end
end
