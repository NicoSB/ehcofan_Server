class FetchMatchDetailsJobJob < ActiveJob::Base
  include SuckerPunch::Job
  queue_as :default

  def perform(*args)
		require 'net/http'
		require 'json'
		puts "------------------------ Scheduled job started: Fetching match details ------------------------"	
		id = args[0]
		uri = URI("http://dvdata.sihf.ch/statistic/api/cms/gameoverview?alias=gameDetail&searchQuery=#{id}&callback=externalStatisticsCallback&language=de")
		response = Net::HTTP.get(uri)
		response.slice!("externalStatisticsCallback(")
		response.slice!(");")

		json = JSON.parse(response)
		status = json["status"]["name"]
		scores = json["result"]["scores"]

		match = Match.find_by nl_id: id
		match.status = status

		if(scores[0]["homeTeam"] != "-")
			match.h1 = scores[0]["homeTeam"]
			match.a1 = scores[0]["awayTeam"]
		end

		if(scores.size >= 2 && scores[1]["homeTeam"] != "-")
			match.h2 = scores[1]["homeTeam"]
			match.a2 = scores[1]["awayTeam"]
		end

		if(scores.size >= 3 && scores[2]["homeTeam"] != "-")
			match.h3 = scores[2]["homeTeam"]
			match.a3 = scores[2]["awayTeam"]
		end

		if(scores.size == 4 && scores[3]["homeTeam"] != "-")
			match.h_ot = scores[3]["homeTeam"]
			match.a_ot = scores[3]["awayTeam"]
		end

		match.save
		status = json["status"]["name"]

		if(status != "Ende")
			FetchMatchDetailsJobJob.perform_in(60, id)
		else
			FetchPlayerStatsJob.perform_in(1800)
		end
	end  
end