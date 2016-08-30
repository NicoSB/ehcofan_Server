class AddUrLsToSchedules < ActiveRecord::Migration
  def up
  	add_column :schedules, :match_urls, :string, array: true
  end
  def down
  	remove_column :schedules, :match_urls
  end
end
