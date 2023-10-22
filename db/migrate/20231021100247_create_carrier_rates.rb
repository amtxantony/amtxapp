class CreateCarrierRates < ActiveRecord::Migration[7.0]
  def change
    create_table :carrier_rates do |t|
      t.string :carrier_product_code
      t.string :zone
      t.integer :weight_band

      t.timestamps
    end
  end
end
