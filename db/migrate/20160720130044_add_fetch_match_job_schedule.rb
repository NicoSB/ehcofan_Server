class AddFetchMatchJobSchedule < ActiveRecord::Migration
  def up
  	rename_column :schedules, :interval, :articles_interval
  	rename_column :schedules, :running, :articles_running
  	add_column :schedules,  :matches_interval, :integer
  	add_column :schedules,  :matches_running, :boolean
  end

  def down
  	rename_column :schedules, :articles_interval, :interval
  	rename_column :schedules, :articles_running, :running
  	remove_column :schedules,  :matches_interval, :integer
  	remove_column :schedules,  :matches_running, :boolean
  end
end
