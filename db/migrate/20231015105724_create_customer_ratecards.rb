class CreateCustomerRatecards < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_ratecards do |t|
      t.string :customer_id
      t.decimal :order_fee
      t.decimal :handle_out_fee
      t.decimal :band_1_1st
      t.decimal :band_1_add
      t.decimal :band_2_1st
      t.decimal :band_2_add
      t.decimal :band_3_1st
      t.decimal :band_3_add
      t.decimal :band_4_1st
      t.decimal :band_4_add
      t.decimal :band_5_1st
      t.decimal :band_5_add
      t.decimal :band_6_1st
      t.decimal :band_6_add
      t.decimal :band_6_extra_per_kg

      t.timestamps
    end
  end
end
