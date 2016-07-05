class Article < ActiveRecord::Base
	validates :title, presence: true
	validates :date, presence: true
	validates :url, uniqueness: true
end
