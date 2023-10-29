class AddPackmToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :packm, :boolean
  end
end
