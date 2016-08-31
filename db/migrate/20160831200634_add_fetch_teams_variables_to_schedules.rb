class AddFetchTeamsVariablesToSchedules < ActiveRecord::Migration
  def up
  	add_column :schedules, :teams_running, :boolean
  	add_column :schedules, :teams_interval, :integer
  end
  def down
  	remove_column :schedules, :teams_running
  	remove_column :schedules, :teams_interval
  end
end
