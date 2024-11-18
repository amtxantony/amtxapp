class RemoveSkuFromObOrder < ActiveRecord::Migration[7.0]
  def change
    remove_column :ob_orders, :product_type, :string
    remove_column :ob_orders, :sku, :string
    remove_column :ob_orders, :unit, :string
    remove_column :ob_orders, :qty, :integer
    remove_column :ob_orders, :weight, :float
    remove_column :ob_orders, :volume, :float
  end
end
