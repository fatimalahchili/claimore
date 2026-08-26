require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user-#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in @user
    @property = Property.create!(address: "123 Main St", moved_on: Date.current)
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
  end

  test "should get show" do
    get property_url(@property)
    assert_response :success
  end

  test "should get edit" do
    get edit_property_url(@property)
    assert_response :success
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
