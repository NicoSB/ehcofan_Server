class AddDefaultToActive < ActiveRecord::Migration
  def up
  	change_column :matches, :active, :boolean,  :default => true
  	change_column :players, :active, :boolean,  :default => true
  	change_column :teams, :active, :boolean,  :default => true
  end
  def down
  	change_column :schedules, :active, :default => nil
  	change_column :players, :active, :default => nil
  	change_column :teams, :active, :default => nil
  end
end
