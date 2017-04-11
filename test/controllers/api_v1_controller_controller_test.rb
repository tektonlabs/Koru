require 'test_helper'

class ApiV1ControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_controller_index_url
    assert_response :success
  end

end
