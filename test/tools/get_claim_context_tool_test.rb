require "test_helper"

class GetClaimContextToolTest < ActiveSupport::TestCase
  test "returns only the current claim and its ordered entries" do
    property = Property.create!(address: "123 Main Street", moved_on: Date.current)
    claim = Claim.create!(property: property, category: "Heating", status: "active")
    later_entry = Entry.create!(claim: claim, title: "Follow-up", date: Date.new(2026, 8, 31))
    earlier_entry = Entry.create!(claim: claim, title: "Reported", date: Date.new(2026, 8, 30))

    result = GetClaimContextTool.new(claim).execute

    assert_equal claim.id, result.dig(:claim, :id)
    assert_equal "123 Main Street", result.dig(:claim, :property_address)
    assert_equal [earlier_entry.id, later_entry.id], result[:entries].pluck(:id)
  end
end
