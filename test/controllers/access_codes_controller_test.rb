require 'test_helper'

class AccessCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @access_code = access_codes(:one)
  end

  test "should get index" do
    get access_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_access_code_url
    assert_response :success
  end

  test "should create access_code" do
    assert_difference('AccessCode.count') do
      post access_codes_url, params: { access_code: { code: @access_code.code, title: @access_code.title } }
    end

    assert_redirected_to access_code_url(AccessCode.last)
  end

  test "should show access_code" do
    get access_code_url(@access_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_access_code_url(@access_code)
    assert_response :success
  end

  test "should update access_code" do
    patch access_code_url(@access_code), params: { access_code: { code: @access_code.code, title: @access_code.title } }
    assert_redirected_to access_code_url(@access_code)
  end

  test "should destroy access_code" do
    assert_difference('AccessCode.count', -1) do
      delete access_code_url(@access_code)
    end

    assert_redirected_to access_codes_url
  end
end
