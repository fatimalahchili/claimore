require "test_helper"

class CreateClaimEntryToolTest < ActiveSupport::TestCase
  setup do
    property = Property.create!(address: "123 Main Street", moved_on: Date.current)
    @claim = Claim.create!(property: property, category: "Heating", status: "active")
    @tool = CreateClaimEntryTool.new(@claim)
  end

  test "creates an entry for the bound claim" do
    assert_difference -> { @claim.entries.count }, 1 do
      result = @tool.execute(
        title: "Called the landlord",
        description: "Reported the broken heater by phone.",
        date: "2026-08-31",
        category: "contact",
        status: "completed"
      )

      assert result[:success]
    end

    entry = @claim.entries.order(:created_at).last
    assert_equal "Called the landlord", entry.title
    assert_equal Date.new(2026, 8, 31), entry.date
  end

  test "rejects an invalid date without creating an entry" do
    assert_no_difference -> { @claim.entries.count } do
      result = @tool.execute(title: "Called", description: "Called landlord", date: "today")

      assert_not result[:success]
      assert_equal "Date must use YYYY-MM-DD format", result[:error]
    end
  end
end
