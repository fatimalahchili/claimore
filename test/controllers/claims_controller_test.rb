require "test_helper"

class ClaimsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "claim-owner-#{SecureRandom.hex(4)}@example.com", password: "password")
    @other_user = User.create!(email: "other-#{SecureRandom.hex(4)}@example.com", password: "password")
    @property = Property.create!(address: "123 Main St", moved_on: Date.current)
    Tenant.create!(user: @user, property: @property)
    @claim = Claim.create!(property: @property, category: "damage", status: "active")
    @old_entry = Entry.create!(claim: @claim, title: "Old entry", date: Date.current - 2.days, status: "resolved")
    @next_entry = Entry.create!(claim: @claim, title: "Next entry", date: Date.current + 1.day, status: "pending")
    @later_entry = Entry.create!(claim: @claim, title: "Later entry", date: Date.current + 3.days, status: "escalated")
    sign_in @user
  end

  test "show orders entries descending and marks the next entry for focus" do
    get claim_url(@claim)

    assert_response :success
    titles = css_select(".timeline-entry h6").map { |element| element.text.strip }
    assert_equal ["Later entry", "Next entry", "Old entry"], titles
    assert_select "[data-timeline-focus-target='current']", count: 1, text: /Next entry/
    assert_select ".timeline-entry--escalated", text: /Later entry/
    assert_select ".timeline-entry--resolved", text: /Old entry/
  end

  test "show rejects users who do not belong to the claim" do
    sign_out @user
    sign_in @other_user

    get claim_url(@claim)

    assert_redirected_to root_url
    assert_equal "Not authorized.", flash[:alert]
  end

  test "destroy archives the claim instead of deleting it" do
    assert_no_difference("Claim.count") do
      delete claim_url(@claim)
    end

    assert_predicate @claim.reload, :archived?
    assert_redirected_to claims_url
  end
end
