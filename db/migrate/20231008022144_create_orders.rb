class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_source
      t.datetime :order_date  
      t.string :order_number
      t.string :code
      t.boolean :urgent
      t.string :customer_id
      t.string :ship_to
      t.string :postcode
      t.string :suburb
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.timestamps
    end
  end
end
