require "test_helper"

class CarrierRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @carrier_rate = carrier_rates(:one)
  end

  test "should get index" do
    get carrier_rates_url
    assert_response :success
  end

  test "should get new" do
    get new_carrier_rate_url
    assert_response :success
  end

  test "should create carrier_rate" do
    assert_difference("CarrierRate.count") do
      post carrier_rates_url, params: { carrier_rate: { carrier_product_code: @carrier_rate.carrier_product_code, weight_band: @carrier_rate.weight_band, zone: @carrier_rate.zone } }
    end

    assert_redirected_to carrier_rate_url(CarrierRate.last)
  end

  test "should show carrier_rate" do
    get carrier_rate_url(@carrier_rate)
    assert_response :success
  end

  test "should get edit" do
    get edit_carrier_rate_url(@carrier_rate)
    assert_response :success
  end

  test "should update carrier_rate" do
    patch carrier_rate_url(@carrier_rate), params: { carrier_rate: { carrier_product_code: @carrier_rate.carrier_product_code, weight_band: @carrier_rate.weight_band, zone: @carrier_rate.zone } }
    assert_redirected_to carrier_rate_url(@carrier_rate)
  end

  test "should destroy carrier_rate" do
    assert_difference("CarrierRate.count", -1) do
      delete carrier_rate_url(@carrier_rate)
    end

    assert_redirected_to carrier_rates_url
  end
end
