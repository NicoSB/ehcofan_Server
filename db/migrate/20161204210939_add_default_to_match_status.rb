class AddDefaultToMatchStatus < ActiveRecord::Migration
  def up
  	change_column :matches, :status, :string,  :default => "_"
  end
  def down
  	change_column :schedules, :status, :boolean
  end
end
