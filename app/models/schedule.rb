class Schedule < ActiveRecord::Base
	validates :interval, presence: true, numericality: { greather_than: 0}
end
