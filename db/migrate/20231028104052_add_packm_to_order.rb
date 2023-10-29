class AddPackmToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :packm_price, :float, :default => -1.0
  end
end
