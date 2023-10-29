require "test_helper"

class PackMaterialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pack_material = pack_materials(:one)
  end

  test "should get index" do
    get pack_materials_url
    assert_response :success
  end

  test "should get new" do
    get new_pack_material_url
    assert_response :success
  end

  test "should create pack_material" do
    assert_difference("PackMaterial.count") do
      post pack_materials_url, params: { pack_material: { maxcube: @pack_material.maxcube, name: @pack_material.name, price: @pack_material.price, size: @pack_material.size } }
    end

    assert_redirected_to pack_material_url(PackMaterial.last)
  end

  test "should show pack_material" do
    get pack_material_url(@pack_material)
    assert_response :success
  end

  test "should get edit" do
    get edit_pack_material_url(@pack_material)
    assert_response :success
  end

  test "should update pack_material" do
    patch pack_material_url(@pack_material), params: { pack_material: { maxcube: @pack_material.maxcube, name: @pack_material.name, price: @pack_material.price, size: @pack_material.size } }
    assert_redirected_to pack_material_url(@pack_material)
  end

  test "should destroy pack_material" do
    assert_difference("PackMaterial.count", -1) do
      delete pack_material_url(@pack_material)
    end

    assert_redirected_to pack_materials_url
  end
end
