require "application_system_test_case"

class PackMaterialsTest < ApplicationSystemTestCase
  setup do
    @pack_material = pack_materials(:one)
  end

  test "visiting the index" do
    visit pack_materials_url
    assert_selector "h1", text: "Pack materials"
  end

  test "should create pack material" do
    visit pack_materials_url
    click_on "New pack material"

    fill_in "Maxcube", with: @pack_material.maxcube
    fill_in "Name", with: @pack_material.name
    fill_in "Price", with: @pack_material.price
    fill_in "Size", with: @pack_material.size
    click_on "Create Pack material"

    assert_text "Pack material was successfully created"
    click_on "Back"
  end

  test "should update Pack material" do
    visit pack_material_url(@pack_material)
    click_on "Edit this pack material", match: :first

    fill_in "Maxcube", with: @pack_material.maxcube
    fill_in "Name", with: @pack_material.name
    fill_in "Price", with: @pack_material.price
    fill_in "Size", with: @pack_material.size
    click_on "Update Pack material"

    assert_text "Pack material was successfully updated"
    click_on "Back"
  end

  test "should destroy Pack material" do
    visit pack_material_url(@pack_material)
    click_on "Destroy this pack material", match: :first

    assert_text "Pack material was successfully destroyed"
  end
end
