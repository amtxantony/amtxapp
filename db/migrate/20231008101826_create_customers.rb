class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :order_no_prefix
      t.string :email
      t.string :tier

      t.timestamps
    end
  end
end
