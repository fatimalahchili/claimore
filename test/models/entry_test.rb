require "test_helper"

class EntryTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  setup do
    property = Property.create!(address: "123 Main Street", moved_on: Date.current)
    @claim = Claim.create!(property: property, category: "Heating", status: "active")
  end

  test "broadcasts the new entry to the claim's entries stream on creation" do
    messages = capture_broadcasts("claim_#{@claim.id}_entries") do
      @claim.entries.create!(title: "Called the landlord", description: "Reported the leak.", date: Date.current)
    end

    assert_match(/action="remove" target="entries_empty_state"/, messages.first)
    assert_match(/action="prepend" target="entries"/, messages.last)
    assert_match "Called the landlord", messages.last
  end
end
