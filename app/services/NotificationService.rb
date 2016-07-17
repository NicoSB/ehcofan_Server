class NotificationService
	@firebase_key = 'key=AIzaSyBaLCHWTBUrRa_h5AeXjBYcfz3OIz7q8iE'
	def send_message
		require 'net/http'
		require 'net/https'
		require 'uri'

		uri = URI.parse("https://fcm.googleapis.com/fcm/send")
		request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AIzaSyBaLCHWTBUrRa_h5AeXjBYcfz3OIz7q8iE'})

		@notification = {
			"title" => "Testmessage"
			"body" => "Teesswdakjlhfg"
		}.to_json

		@to_send = { 
			"to" => "/topics/news"
			"notification" => @notification
		}.to_json

		req.body = "[ #{@to_send}"
		res = https.request(req)
		puts "Response #{res.code} #{res.message}: #{res.body}"
	end
end