# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_11_16_005741) do
  create_table "bills", force: :cascade do |t|
    t.integer "customer_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "orders"
    t.boolean "invoiced"
    t.datetime "invoiced_date"
    t.string "bill_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "handling_fee"
    t.decimal "shipping_fee"
  end

  create_table "carrier_rates", force: :cascade do |t|
    t.string "carrier_product_code"
    t.string "zone"
    t.integer "weight_band"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "rate"
  end

  create_table "customer_ratecards", force: :cascade do |t|
    t.string "customer_id"
    t.decimal "order_fee"
    t.decimal "handle_out_fee"
    t.decimal "band_1_1st"
    t.decimal "band_1_add"
    t.decimal "band_2_1st"
    t.decimal "band_2_add"
    t.decimal "band_3_1st"
    t.decimal "band_3_add"
    t.decimal "band_4_1st"
    t.decimal "band_4_add"
    t.decimal "band_5_1st"
    t.decimal "band_5_add"
    t.decimal "band_6_1st"
    t.decimal "band_6_add"
    t.decimal "band_6_extra_per_kg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "order_no_prefix"
    t.string "email"
    t.string "tier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "packm"
  end

  create_table "ob_order_items", force: :cascade do |t|
    t.string "order_no"
    t.string "product_type"
    t.string "sku"
    t.string "unit"
    t.integer "qty"
    t.float "weight"
    t.float "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_line"
  end

  create_table "ob_orders", force: :cascade do |t|
    t.string "warehouse"
    t.string "vendor"
    t.string "order_no"
    t.string "so_type"
    t.string "client_id"
    t.date "delivery_date"
    t.date "conf_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.string "order_number"
    t.string "item_SKU"
    t.string "item_barcode"
    t.integer "quantity"
    t.string "item_name"
    t.string "item_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight"
  end

  create_table "order_packages", force: :cascade do |t|
    t.string "package_id"
    t.decimal "weight"
    t.decimal "length"
    t.decimal "width"
    t.decimal "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_number"
    t.integer "weight_band"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_source"
    t.datetime "order_date"
    t.string "order_number"
    t.string "code"
    t.boolean "urgent"
    t.string "customer_id"
    t.string "ship_to"
    t.string "postcode"
    t.string "suburb"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "their_order_id"
    t.boolean "billed"
    t.string "carrier_service_code"
    t.decimal "handling_fee"
    t.decimal "shipping_fee"
    t.integer "status"
    t.float "packm_price", default: -1.0
  end

  create_table "pack_materials", force: :cascade do |t|
    t.string "name"
    t.string "size"
    t.float "price"
    t.float "maxcube"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade do |t|
    t.string "shipment_number"
    t.string "order_ref"
    t.string "order_ref_alt"
    t.string "code"
    t.string "ship_from_name"
    t.string "ship_from_company"
    t.string "ship_from_postcode"
    t.string "ship_from_suburb"
    t.string "ship_from_city"
    t.string "ship_from_state"
    t.string "ship_from_country"
    t.string "ship_from_phone"
    t.string "ship_from_email"
    t.string "ship_from_building"
    t.string "ship_from_street"
    t.string "ship_to_name"
    t.string "ship_to_company"
    t.string "ship_to_postcode"
    t.string "ship_to_suburb"
    t.string "ship_to_city"
    t.string "ship_to_state"
    t.string "ship_to_country"
    t.string "ship_to_phone"
    t.string "ship_to_email"
    t.string "ship_to_building"
    t.string "ship_to_street"
    t.float "weight"
    t.float "width"
    t.float "length"
    t.float "height"
    t.string "carrier"
    t.string "carrier_product_code"
    t.boolean "atl"
    t.boolean "signature_required"
    t.boolean "weekend_delivery"
    t.boolean "return_label"
    t.string "item_qty_shipped"
    t.datetime "label_printed_date"
    t.datetime "pick_up_date"
    t.datetime "out_for_delivery_date"
    t.datetime "delivered_date"
    t.string "manifest_number"
    t.datetime "manifest_date"
    t.string "tracking_number"
    t.string "pod"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 2
  end

end
