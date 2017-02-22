class Article < ActiveRecord::Base
	validates :title, presence: true
	validates :date, presence: true
	validates :url, uniqueness: true
	has_attached_file :news_image, :default_url => "/images/default.jpg"
	validates_attachment :news_image, content_type: { content_type: /\Aimage\/.*\Z/ }

	after_create :send_notification, on: :create

	private
		def send_notification
			require 'net/http'
			require 'net/https'
			require 'uri'
			require 'openssl'

			uri = URI.parse("https://fcm.googleapis.com/fcm/send")
			https = Net::HTTP.new(uri.host,uri.port)
			https.use_ssl = true
			headers = {
			  'Authorization' => "key=" + ENV['FIREBASE_KEY'],
			  'Content-Type' => 'application/json'
			}

			body = self.text
			body.gsub!(/<[\w\s=\"]+>/, "")

			topic2 = "/topics/" + ENV['TOPIC_NEWS2']		
			to_send2 = { 
				"to" => topic2,
				"data" => {
					"title" => self.title,
					"body" => body[0,body.index(".")].strip(),
					"type" => "news",
					"news_id" => self.id
				},
				"time_to_live" => 172800 #equals 2 days
			}.to_json

			topic = "/topics/" + ENV['TOPIC_NEWS']
			to_send = { 
				"to" => topic,
				"notification" => {
					"title" => self.title,
					"body" => body[0,body.index(".")]
				},
				"time_to_live" => 172800 #equals 2 days
			}.to_json

			request = Net::HTTP::Post.new(uri.path, initheader = headers)
			request.body = to_send
			https.verify_mode = OpenSSL::SSL::VERIFY_NONE

			res = https.request(request)			
			puts "Response (#{topic}) #{res.code} #{res.message}: #{res.body}"

			request.body = to_send2

			res = https.request(request)
			puts "Response (#{topic2}) #{res.code} #{res.message}: #{res.body}"
		end
end
 