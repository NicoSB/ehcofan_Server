class Article < ActiveRecord::Base
	validates :title, presence: true
	validates :date, presence: true
	validates :url, uniqueness: true
	has_attached_file :news_image, :default_url => "/images/default.jpg"
	validates_attachment :news_image, content_type: { content_type: /\Aimage\/.*\Z/ }
end
