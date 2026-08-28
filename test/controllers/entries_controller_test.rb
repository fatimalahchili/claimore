require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user-#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in @user
    @property = Property.create!(address: "123 Main St", moved_on: Date.current)
    Tenant.create!(user: @user, property: @property)
    @claim = Claim.create!(property: @property, category: "damage", status: "active")
    @entry = Entry.create!(claim: @claim, title: "Broken window", description: "Cracked pane", category: "damage")
  end

  test "should get index" do
    get entries_url
    assert_response :success
  end

  test "should get new" do
    get new_entry_url
    assert_response :success
  end

  test "should create entry" do
    assert_difference("Entry.count") do
      post entries_url, params: {
        entry: { title: "Water damage", description: "Leaky roof", category: "damage", claim_id: @claim.id }
      }
    end
    assert_redirected_to entry_url(Entry.last)
  end

  test "should get show" do
    get entry_url(@entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_entry_url(@entry)
    assert_response :success
  end

  test "should update entry" do
    patch entry_url(@entry), params: { entry: { title: "Updated title" } }
    assert_redirected_to entry_url(@entry)
  end

  test "should destroy entry" do
    assert_difference("Entry.count", -1) do
      delete entry_url(@entry)
    end
    assert_redirected_to entries_url
  end
end
