class AddGameidsToPlayoff < ActiveRecord::Migration
  def change
  	add_column :playoffs, :gameids, :integer, array:true, default: []
  end
end
