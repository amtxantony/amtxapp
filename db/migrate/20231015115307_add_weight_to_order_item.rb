class AddWeightToOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :weight, :decimal
  end
end
