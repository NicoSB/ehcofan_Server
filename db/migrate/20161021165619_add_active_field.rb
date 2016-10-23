class AddActiveField < ActiveRecord::Migration
  def up
  	add_column :matches, :active, :boolean,  :default => true
  	add_column :players, :active, :boolean,  :default => true
  	add_column :teams, :active, :boolean,  :default => true
  end
  def down
  	remove_column :schedules, :active
  	remove_column :players, :active
  	remove_column :teams, :active
  end
end
