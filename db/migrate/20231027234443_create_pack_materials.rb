class CreatePackMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :pack_materials do |t|
      t.string :name
      t.string :size
      t.float :price
      t.float :maxcube

      t.timestamps
    end
  end
end
