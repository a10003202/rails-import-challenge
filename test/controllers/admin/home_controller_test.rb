require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin)
  end

  test "should get index" do
    get admin_home_index_url
    assert_response :success
  end

  test "import_purchases without file" do
    post import_purchases_admin_home_index_url
    assert_response :unprocessable_entity
  end

end
