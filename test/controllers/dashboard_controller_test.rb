require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user-#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in @user

    @property = Property.create!(address: "123 Main St", moved_on: Date.current)
    Tenant.create!(user: @user, property: @property)

    claim = Claim.create!(property: @property, category: "damage", status: "active")
    Entry.create!(claim: claim, title: "Upcoming inspection", date: Date.current + 3.days)
  end

  test "shows next event and active claims count" do
    get dashboard_url

    assert_response :success
    assert_select "h5.fw-bold.text-dark.mb-0", text: "Upcoming inspection"
    assert_select "div.fs-2.fw-bold.text-dark", text: "1"
    assert_select "a[href=?]", property_path(@property), text: /123 Main St/
  end
end
