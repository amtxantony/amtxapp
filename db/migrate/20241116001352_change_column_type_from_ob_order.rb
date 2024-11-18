class ChangeColumnTypeFromObOrder < ActiveRecord::Migration[7.0]
  def change
    change_column :ob_orders, :delivery_date, :date
    change_column :ob_orders, :conf_date, :date
  end
end
