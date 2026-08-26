require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get entries_new_url
    assert_response :success
  end

  test "should get create" do
    get entries_create_url
    assert_response :success
  end

  test "should get update" do
    get entries_update_url
    assert_response :success
  end

  test "should get destroy" do
    get entries_destroy_url
    assert_response :success
  end
end
