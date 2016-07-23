class AddPositionAndNumberColumnsToPlayer < ActiveRecord::Migration
  def up
  	add_column :players, :number, :integer
  	add_column :players, :position, :string
  end

  def down
  	remove_column :players, :number
  	remove_column :players, :position
  end
end
