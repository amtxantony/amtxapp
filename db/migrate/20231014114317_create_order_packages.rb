class CreateOrderPackages < ActiveRecord::Migration[7.0]
  def change
    create_table :order_packages do |t|
      t.string :package_id
      t.decimal :weight
      t.decimal :length
      t.decimal :width
      t.decimal :height

      t.timestamps
    end
  end
end
