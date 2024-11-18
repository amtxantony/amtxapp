class CreateObOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :ob_order_items do |t|
      t.string :order_no
      t.string :product_type
      t.string :sku
      t.string :unit
      t.integer :qty
      t.float :weight
      t.float :volume

      t.timestamps
    end
  end
end
