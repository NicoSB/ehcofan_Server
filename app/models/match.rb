class Match < ActiveRecord::Base
	validates :home_team, presence: true
	validates :away_team, presence: true
	validates :competition, presence: true
	validates :datetime, presence: true
	validates :nl_id, uniqueness: true
end
