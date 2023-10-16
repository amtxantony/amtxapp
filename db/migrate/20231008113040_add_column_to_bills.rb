class AddColumnToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :handling_fee, :decimal
    add_column :bills, :shipping_fee, :decimal
  end
end
