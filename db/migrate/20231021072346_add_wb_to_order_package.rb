class AddWbToOrderPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :order_packages, :weight_band, :integer
  end
end
