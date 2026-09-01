require "test_helper"

class UpdateClaimEntryToolTest < ActiveSupport::TestCase
  setup do
    property = Property.create!(address: "123 Main Street", moved_on: Date.current)
    @claim = Claim.create!(property: property, category: "Heating", status: "active")
    @entry = @claim.entries.create!(title: "Called landlord", description: "Reported issue", date: Date.new(2026, 8, 30))
    @tool = UpdateClaimEntryTool.new(@claim)
  end

  test "updates an existing entry without creating a duplicate" do
    assert_no_difference -> { @claim.entries.count } do
      result = @tool.execute(
        entry_id: @entry.id,
        title: "Emailed landlord",
        description: "Sent a written repair request.",
        date: "2026-08-31",
        status: "pending"
      )

      assert result[:success]
    end

    @entry.reload
    assert_equal "Emailed landlord", @entry.title
    assert_equal "Sent a written repair request.", @entry.description
    assert_equal Date.new(2026, 8, 31), @entry.date
    assert_equal "pending", @entry.status
  end

  test "cannot update an entry belonging to another claim" do
    other_claim = Claim.create!(property: @claim.property, category: "Plumbing", status: "active")
    other_entry = other_claim.entries.create!(title: "Other event")

    result = @tool.execute(entry_id: other_entry.id, title: "Changed")

    assert_not result[:success]
    assert_equal "Timeline entry was not found on this claim", result[:error]
    assert_equal "Other event", other_entry.reload.title
  end

  test "rejects an update with no changed fields" do
    result = @tool.execute(entry_id: @entry.id)

    assert_not result[:success]
    assert_equal "Provide at least one field to update", result[:error]
  end
end
