class AddNlIdtoMatches < ActiveRecord::Migration
  def up
  	add_column :matches, :nl_id, :integer
  end

  def down
  	remove_column :matches, :nl_id
  end
end
