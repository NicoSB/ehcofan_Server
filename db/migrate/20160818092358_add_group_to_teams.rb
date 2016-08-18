class AddGroupToTeams < ActiveRecord::Migration
  def up
  	add_column :teams, :group, :string
  end

  def down
  	remove_column :teams, :group
  end
end
