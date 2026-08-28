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
end
