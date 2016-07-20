class Schedule < ActiveRecord::Base
	validates :articles_interval, numericality: { greather_than: 0}
	validates :matches_interval, numericality: { greather_than: 0}
end
