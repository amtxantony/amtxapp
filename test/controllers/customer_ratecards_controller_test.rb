require "test_helper"

class CustomerRatecardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_ratecard = customer_ratecards(:one)
  end

  test "should get index" do
    get customer_ratecards_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_ratecard_url
    assert_response :success
  end

  test "should create customer_ratecard" do
    assert_difference("CustomerRatecard.count") do
      post customer_ratecards_url, params: { customer_ratecard: { band_1_1st: @customer_ratecard.band_1_1st, band_1_add: @customer_ratecard.band_1_add, band_2_1st: @customer_ratecard.band_2_1st, band_2_add: @customer_ratecard.band_2_add, band_3_1st: @customer_ratecard.band_3_1st, band_3_add: @customer_ratecard.band_3_add, band_4_1st: @customer_ratecard.band_4_1st, band_4_add: @customer_ratecard.band_4_add, band_5_1st: @customer_ratecard.band_5_1st, band_5_add: @customer_ratecard.band_5_add, band_6_1st: @customer_ratecard.band_6_1st, band_6_add: @customer_ratecard.band_6_add, band_6_extra_per_kg: @customer_ratecard.band_6_extra_per_kg, customer_id: @customer_ratecard.customer_id, handle_out_fee: @customer_ratecard.handle_out_fee, order_fee: @customer_ratecard.order_fee } }
    end

    assert_redirected_to customer_ratecard_url(CustomerRatecard.last)
  end

  test "should show customer_ratecard" do
    get customer_ratecard_url(@customer_ratecard)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_ratecard_url(@customer_ratecard)
    assert_response :success
  end

  test "should update customer_ratecard" do
    patch customer_ratecard_url(@customer_ratecard), params: { customer_ratecard: { band_1_1st: @customer_ratecard.band_1_1st, band_1_add: @customer_ratecard.band_1_add, band_2_1st: @customer_ratecard.band_2_1st, band_2_add: @customer_ratecard.band_2_add, band_3_1st: @customer_ratecard.band_3_1st, band_3_add: @customer_ratecard.band_3_add, band_4_1st: @customer_ratecard.band_4_1st, band_4_add: @customer_ratecard.band_4_add, band_5_1st: @customer_ratecard.band_5_1st, band_5_add: @customer_ratecard.band_5_add, band_6_1st: @customer_ratecard.band_6_1st, band_6_add: @customer_ratecard.band_6_add, band_6_extra_per_kg: @customer_ratecard.band_6_extra_per_kg, customer_id: @customer_ratecard.customer_id, handle_out_fee: @customer_ratecard.handle_out_fee, order_fee: @customer_ratecard.order_fee } }
    assert_redirected_to customer_ratecard_url(@customer_ratecard)
  end

  test "should destroy customer_ratecard" do
    assert_difference("CustomerRatecard.count", -1) do
      delete customer_ratecard_url(@customer_ratecard)
    end

    assert_redirected_to customer_ratecards_url
  end
end
