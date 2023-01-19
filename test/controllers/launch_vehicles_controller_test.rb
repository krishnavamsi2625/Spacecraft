require "test_helper"

class LaunchVehiclesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get launch_vehicles_index_url
    assert_response :success
  end
end
