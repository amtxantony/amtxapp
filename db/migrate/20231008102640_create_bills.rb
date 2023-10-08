class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.integer :customer_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :orders
      t.boolean :invoiced
      t.datetime :invoiced_date
      t.string :bill_type

      t.timestamps
    end
  end
end
