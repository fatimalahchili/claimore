require "test_helper"

class ClaimsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "blesson-#{SecureRandom.hex(4)}@example.com", password: "password")
    @other_user = User.create!(email: "other-#{SecureRandom.hex(4)}@example.com", password: "password")
    @property = Property.create!(address: "123 Main St", moved_on: Date.current)
    @other_property = Property.create!(address: "456 Hidden St", moved_on: Date.current)
    Tenant.create!(user: @user, property: @property)
    Tenant.create!(user: @other_user, property: @other_property)
    @active_claim = Claim.create!(property: @property, category: "Active leak", status: "active")
    @archived_claim = Claim.create!(property: @property, category: "Old heating issue", status: "archived")
    @hidden_claim = Claim.create!(property: @other_property, category: "Private claim", status: "active")
    sign_in @user
  end

  test "index shows active claims for the current user's property" do
    get claims_url

    assert_response :success
    assert_select "h3", text: @active_claim.category
    assert_select "h3", { text: @archived_claim.category, count: 0 }
    assert_select "h3", { text: @hidden_claim.category, count: 0 }
  end

  test "index can reveal archived claims" do
    get claims_url(property_id: @property.id, show_archived: 1)

    assert_response :success
    assert_select "h3", text: @active_claim.category
    assert_select "h3", text: @archived_claim.category
    assert_select "a", text: "Hide archived claims"
  end

  test "index rejects properties that do not belong to the current user" do
    get claims_url(property_id: @other_property.id)

    assert_response :not_found
  end

  test "new shows the current user's properties and selects the requested property" do
    get new_claim_url(property_id: @property.id)

    assert_response :success
    assert_select "h1", text: "Add a new claim"
    assert_select "select[name='claim[property_id]']" do
      assert_select "option[value=?][selected]", @property.id.to_s, text: @property.address
      assert_select "option[value=?]", @other_property.id.to_s, count: 0
    end
    assert_select "input[type='submit'][value='Create claim']"
  end

  test "create associates the claim with the selected property" do
    assert_difference("@property.claims.count") do
      post claims_url, params: {
        claim: { category: "Broken window", status: "active", property_id: @property.id }
      }
    end

    claim = @property.claims.order(:created_at).last
    assert_redirected_to claim_url(claim)
    assert_equal "Broken window", claim.category
  end

  test "create rejects a property that does not belong to the current user" do
    assert_no_difference("Claim.count") do
      post claims_url, params: {
        claim: { category: "Private issue", status: "active", property_id: @other_property.id }
      }
    end

    assert_response :not_found
  end

  test "show subscribes to the claim's entries stream and renders existing entries" do
    entry = @active_claim.entries.create!(title: "Called the landlord", description: "Reported the leak.", date: Date.current)

    get claim_url(@active_claim)

    assert_response :success
    assert_select "turbo-cable-stream-source"
    assert_select "#entries" do
      assert_select "##{dom_id(entry)}", text: /Called the landlord/
    end
  end

  test "show renders an empty state inside the entries container when there are no entries" do
    get claim_url(@active_claim)

    assert_response :success
    assert_select "#entries #entries_empty_state"
  end
end
