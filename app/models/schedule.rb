class Schedule < ActiveRecord::Base
	validates :articles_interval, numericality: {:allow_blank => true, greather_than: 0}
	validates :matches_interval, numericality: {:allow_blank => true, greather_than: 0} 
end
