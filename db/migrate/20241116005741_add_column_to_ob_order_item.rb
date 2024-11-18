class AddColumnToObOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :ob_order_items, :total_line, :integer
  end
end
