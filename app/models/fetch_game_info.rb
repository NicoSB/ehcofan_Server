def send_goal_notification
	require 'net/http'
	require 'json'
	puts "------------------------ Fetch goal_scorer ------------------------"	
	current_score = "2:0"
	id = 20171115071138
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
				puts text
			end
		end
	end
end