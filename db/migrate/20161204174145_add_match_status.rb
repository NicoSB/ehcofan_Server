class AddMatchStatus < ActiveRecord::Migration
  def up
  	add_column :matches, :status, :boolean
  end
  def down
  	remove_column :schedules, :status
  end
end
