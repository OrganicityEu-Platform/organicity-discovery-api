require 'test_helper'

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get '/'
    assert_response :success
  end

  test "info contains" do
    get '/'
    assert_includes response.body, 'Welcome to'
  end

end
