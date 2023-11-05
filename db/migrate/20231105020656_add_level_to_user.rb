class AddLevelToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :Users, :level, :integer, :default => 2
  end
end
