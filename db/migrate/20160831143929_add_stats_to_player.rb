class AddStatsToPlayer < ActiveRecord::Migration
  def up
  	add_column :players, :games, :integer
  	add_column :players, :goals, :integer
  	add_column :players, :assists, :integer
  	add_column :players, :pim, :integer
  end

  def down
  	remove_column :players, :games
  	remove_column :players, :goals
  	remove_column :players, :assists
  	remove_column :players, :pim
  end
end
