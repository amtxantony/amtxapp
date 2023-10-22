class AddColumnToCarrierRate < ActiveRecord::Migration[7.0]
  def change
    add_column :carrier_rates, :rate, :float
  end
end
