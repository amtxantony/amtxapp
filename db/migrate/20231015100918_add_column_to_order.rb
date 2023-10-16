class AddColumnToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :carrier_service_code, :string
  end
end
