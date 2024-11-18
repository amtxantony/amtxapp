class CreateObOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :ob_orders do |t|
      t.string :warehouse
      t.string :vendor
      t.string :order_no
      t.string :so_type
      t.string :product_type
      t.string :client_id
      t.string :sku
      t.string :unit
      t.integer :qty
      t.float :weight
      t.float :volume
      t.datetime :delivery_date
      t.datetime :conf_date

      t.timestamps
    end
  end
end
