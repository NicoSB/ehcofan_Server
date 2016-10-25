class Player < ActiveRecord::Base
	has_attached_file :player_image
	validates_attachment_content_type :player_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

	def destroy
		update_attribute(:active, false)
	end
end
