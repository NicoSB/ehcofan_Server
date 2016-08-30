class AddLimitNoNlId < ActiveRecord::Migration  
	def up
  		change_column :matches, :nl_id, :integer, :limit => 8
  	end

  def down
  		change_column :matches, :nl_id, :integer
  end
end
