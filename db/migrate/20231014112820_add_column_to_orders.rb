class AddColumnToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :their_order_id, :string
    add_column :orders, :billed, :boolean
  end
end
