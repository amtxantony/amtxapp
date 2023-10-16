class AddColumnToOrderPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :order_packages, :order_number, :string
  end
end
