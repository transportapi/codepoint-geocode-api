require 'test_helper'

class PostcodesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get near" do
    get :near
    assert_response :success
  end

end
