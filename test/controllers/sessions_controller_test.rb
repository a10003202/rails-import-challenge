require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin)
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "login with invalid information" do
    post login_path, params: { email: "", password: "" }
    assert_redirected_to login_path
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { email: @user.email, password: 'admin' }
    assert logged_in?
    assert_equal current_user.id, @user.id
  end

  test "should get destroy" do
    get logout_url
    assert_not logged_in?
    assert_redirected_to login_path
  end

end
