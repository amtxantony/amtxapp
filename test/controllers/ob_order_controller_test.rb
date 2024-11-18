require "test_helper"

class ObOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ob_order_index_url
    assert_response :success
  end

  test "should get acr_upload" do
    get ob_order_acr_upload_url
    assert_response :success
  end

  test "should get oc_upload" do
    get ob_order_oc_upload_url
    assert_response :success
  end
end
