require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates an initial property from signup property fields" do
    user = User.create!(
      name: "Test User",
      email: "user-#{SecureRandom.hex(4)}@example.com",
      password: "password",
      property_address: "123 Signup St",
      property_moved_on: Date.current
    )

    property = user.properties.first

    assert_equal "123 Signup St", property.address
    assert_equal Date.current, property.moved_on
    assert_equal "main_tenant", property.tenants.first.role
    assert_equal "added", property.tenants.first.status
  end
end
