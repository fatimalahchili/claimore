require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user-#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in @user
    @property = Property.create!(address: "123 Main St", moved_on: Date.current)
    Tenant.create!(user: @user, property: @property, role: :main_tenant, status: :tenant)
  end

  test "should get new" do
    get new_property_url
    assert_response :success
  end

  test "should create property" do
    assert_difference("Property.count") do
      post properties_url, params: { property: { address: "456 Oak Ave", moved_on: Date.current } }
    end
    assert_redirected_to property_url(Property.last)
    assert_equal @user, Property.last.tenants.main_tenant.first.user
  end

  test "should get show" do
    Claim.create!(property: @property, category: "Heating", status: "active")
    get property_url(@property)

    assert_response :success
    assert_select "h1", text: "123 Main St"
    assert_select "a[href=?]", property_tenants_path(@property), text: /View all tenants/
    assert_select "a[href=?]", claims_path(property_id: @property.id), text: /View property claims/
  end

  test "rejects a property that does not belong to the current user" do
    other_property = Property.create!(address: "456 Hidden St", moved_on: Date.current)

    get property_url(other_property)

    assert_redirected_to root_url
  end

  test "should update property" do
    patch property_url(@property), params: { property: { address: "789 Pine Rd" } }
    assert_redirected_to property_url(@property)
  end

  test "should destroy property" do
    assert_difference("Property.count", -1) do
      delete property_url(@property)
    end
    assert_redirected_to new_property_url
  end
end
