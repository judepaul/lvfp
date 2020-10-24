require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get users_edit_url
    assert_response :success
  end

  test "should get update_password" do
    get users_update_password_url
    assert_response :success
  end

end
