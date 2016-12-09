class Match < ActiveRecord::Base
	validates :home_team, presence: true
	validates :away_team, presence: true
	validates :competition, presence: true
	validates :datetime, presence: true
	validates :nl_id, uniqueness: true

	after_update :fetch_goal_scorer

	def destroy
		update_attribute(:active, false)
	end


	def fetch_goal_scorer
		if((:h1_changed? || :h2_changed || :h3_changed || :h_ot_changed || :a1_changed || :a2_changed || :a3_changed || :a_ot_changed) && self.status.length > 4)
			require 'net/http'
			require 'json'
			puts "------------------------ Fetch goal_scorer ------------------------"	
			id = self.nl_id
			current_score = (self.h1.to_i + self.h2.to_i + self.h3.to_i + self.h_ot.to_i).to_s + ":" +  (self.a1.to_i + self.a2.to_i + self.a3.to_i + self.a_ot.to_i).to_s 
			uri = URI("http://dvdata.sihf.ch/statistic/api/cms/gameoverview?alias=gameDetail&searchQuery=#{id}&callback=externalStatisticsCallback&language=de")

			response = Net::HTTP.get(uri)
			response.slice!("externalStatisticsCallback(")
			response.slice!(");")

			json = JSON.parse(response)
			periods = json["summary"]["periods"]
			for p in periods
				for s in p["goals"]
					new_score = s["text"].slice(/[0-9]+:[0-9]+/)
					if(new_score == current_score)
						text = s["text"]
						text.gsub!("**", "")
						text.gsub!(/ \([0-9]+\)/, "")
						send_goal_notification text
					end
				end
			end
		end
	end

	def send_goal_notification(text)
		require 'net/http'
		require 'net/https'
		require 'uri'
		require 'openssl'

		uri = URI.parse("https://fcm.googleapis.com/fcm/send")
		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		headers = {
		  'Authorization' => "key=" + "AIzaSyBaLCHWTBUrRa_h5AeXjBYcfz3OIz7q8iE",# ENV['FIREBASE_KEY'],
		  'Content-Type' => 'application/json'
		}
		
		to_send = { 
			"to" => "/topics/testgoals",
			"notification" => {
				"title" => "TOOOOOOOOR!",
				"body" => text
			},
			"time_to_live" => 300
		}.to_json

		request = Net::HTTP::Post.new(uri.path, initheader = headers)
		request.body = to_send
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE

		res = https.request(request)
		puts "Response #{res.code} #{res.message}: #{res.body}"

	end
end