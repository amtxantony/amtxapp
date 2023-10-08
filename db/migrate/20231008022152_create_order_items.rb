class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.string :order_number
      t.string :item_SKU
      t.string :item_barcode
      t.integer :quantity
      t.string :item_name
      t.string :item_description 
      t.timestamps
    end
  end
end
