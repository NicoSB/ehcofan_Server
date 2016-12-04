class UpdateMatchesStatus < ActiveRecord::Migration
def up
    Match.find_each do |match|
    	if(match.status == nil)
	      	match.status = "_"
	      	match.save!
	    end
    end
  end

  def down
  end
end
