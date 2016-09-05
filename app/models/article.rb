class Article < ActiveRecord::Base
	validates :title, presence: true
	validates :date, presence: true
	validates :url, uniqueness: true
	has_attached_file :news_image, :default_url => "/images/default.jpg"
	validates_attachment :news_image, content_type: { content_type: /\Aimage\/.*\Z/ }

	#after_save :send_notification, on: :create

	private
		def send_notification
			require 'net/http'
			require 'net/https'
			require 'uri'

			uri = URI.parse("https://fcm.googleapis.com/fcm/send")
			https = Net::HTTP.new(uri.host,uri.port)
			https.use_ssl = true
			headers = {
			  'Authorization' => "key=AIzaSyBaLCHWTBUrRa_h5AeXjBYcfz3OIz7q8iE",
			  'Content-Type' => 'application/json'
			}

			body = self.text
			body.slice!("<b>")
			body.slice!("<strong>")
			
			to_send = { 
				"to" => "/topics/news",
				"notification" => {
					"title" => self.title,
					"body" => body[0,body.index(".")]
				}
			}.to_json

			request = Net::HTTP::Post.new(uri.path, initheader = headers)
			request.body = to_send

			res = https.request(request)
			puts "Response #{res.code} #{res.message}: #{res.body}"
		end
end
