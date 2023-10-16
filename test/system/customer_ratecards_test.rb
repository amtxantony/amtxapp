require "application_system_test_case"

class CustomerRatecardsTest < ApplicationSystemTestCase
  setup do
    @customer_ratecard = customer_ratecards(:one)
  end

  test "visiting the index" do
    visit customer_ratecards_url
    assert_selector "h1", text: "Customer ratecards"
  end

  test "should create customer ratecard" do
    visit customer_ratecards_url
    click_on "New customer ratecard"

    fill_in "Band 1 1st", with: @customer_ratecard.band_1_1st
    fill_in "Band 1 add", with: @customer_ratecard.band_1_add
    fill_in "Band 2 1st", with: @customer_ratecard.band_2_1st
    fill_in "Band 2 add", with: @customer_ratecard.band_2_add
    fill_in "Band 3 1st", with: @customer_ratecard.band_3_1st
    fill_in "Band 3 add", with: @customer_ratecard.band_3_add
    fill_in "Band 4 1st", with: @customer_ratecard.band_4_1st
    fill_in "Band 4 add", with: @customer_ratecard.band_4_add
    fill_in "Band 5 1st", with: @customer_ratecard.band_5_1st
    fill_in "Band 5 add", with: @customer_ratecard.band_5_add
    fill_in "Band 6 1st", with: @customer_ratecard.band_6_1st
    fill_in "Band 6 add", with: @customer_ratecard.band_6_add
    fill_in "Band 6 extra per kg", with: @customer_ratecard.band_6_extra_per_kg
    fill_in "Customer", with: @customer_ratecard.customer_id
    fill_in "Handle out fee", with: @customer_ratecard.handle_out_fee
    fill_in "Order fee", with: @customer_ratecard.order_fee
    click_on "Create Customer ratecard"

    assert_text "Customer ratecard was successfully created"
    click_on "Back"
  end

  test "should update Customer ratecard" do
    visit customer_ratecard_url(@customer_ratecard)
    click_on "Edit this customer ratecard", match: :first

    fill_in "Band 1 1st", with: @customer_ratecard.band_1_1st
    fill_in "Band 1 add", with: @customer_ratecard.band_1_add
    fill_in "Band 2 1st", with: @customer_ratecard.band_2_1st
    fill_in "Band 2 add", with: @customer_ratecard.band_2_add
    fill_in "Band 3 1st", with: @customer_ratecard.band_3_1st
    fill_in "Band 3 add", with: @customer_ratecard.band_3_add
    fill_in "Band 4 1st", with: @customer_ratecard.band_4_1st
    fill_in "Band 4 add", with: @customer_ratecard.band_4_add
    fill_in "Band 5 1st", with: @customer_ratecard.band_5_1st
    fill_in "Band 5 add", with: @customer_ratecard.band_5_add
    fill_in "Band 6 1st", with: @customer_ratecard.band_6_1st
    fill_in "Band 6 add", with: @customer_ratecard.band_6_add
    fill_in "Band 6 extra per kg", with: @customer_ratecard.band_6_extra_per_kg
    fill_in "Customer", with: @customer_ratecard.customer_id
    fill_in "Handle out fee", with: @customer_ratecard.handle_out_fee
    fill_in "Order fee", with: @customer_ratecard.order_fee
    click_on "Update Customer ratecard"

    assert_text "Customer ratecard was successfully updated"
    click_on "Back"
  end

  test "should destroy Customer ratecard" do
    visit customer_ratecard_url(@customer_ratecard)
    click_on "Destroy this customer ratecard", match: :first

    assert_text "Customer ratecard was successfully destroyed"
  end
end
