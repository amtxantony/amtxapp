class AddFeesToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :handling_fee, :decimal
    add_column :orders, :shipping_fee, :decimal
  end
end
