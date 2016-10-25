class Team < ActiveRecord::Base
	def destroy
		update_attribute(:active, false)
	end
end
