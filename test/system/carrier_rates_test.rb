require "application_system_test_case"

class CarrierRatesTest < ApplicationSystemTestCase
  setup do
    @carrier_rate = carrier_rates(:one)
  end

  test "visiting the index" do
    visit carrier_rates_url
    assert_selector "h1", text: "Carrier rates"
  end

  test "should create carrier rate" do
    visit carrier_rates_url
    click_on "New carrier rate"

    fill_in "Carrier product code", with: @carrier_rate.carrier_product_code
    fill_in "Weight band", with: @carrier_rate.weight_band
    fill_in "Zone", with: @carrier_rate.zone
    click_on "Create Carrier rate"

    assert_text "Carrier rate was successfully created"
    click_on "Back"
  end

  test "should update Carrier rate" do
    visit carrier_rate_url(@carrier_rate)
    click_on "Edit this carrier rate", match: :first

    fill_in "Carrier product code", with: @carrier_rate.carrier_product_code
    fill_in "Weight band", with: @carrier_rate.weight_band
    fill_in "Zone", with: @carrier_rate.zone
    click_on "Update Carrier rate"

    assert_text "Carrier rate was successfully updated"
    click_on "Back"
  end

  test "should destroy Carrier rate" do
    visit carrier_rate_url(@carrier_rate)
    click_on "Destroy this carrier rate", match: :first

    assert_text "Carrier rate was successfully destroyed"
  end
end
