class FetchMatchesJob < ActiveJob::Base
  include SuckerPunch::Job
  URL = "http://www.ehco.ch/de/playingschedule---0--0--0--1.html"

  def perform(*args)
  	ActiveRecord::Base.connection_pool.with_connection do
  # 		if(Schedule.count > 0)
	 #  		schedule = Schedule.find(1)
	 #  		if(schedule.matches_running)
	 #  			puts "------------------------ Scheduled job started: Fetching matches"	
	  			
	 #  			fetch_matches "http://dvdata.sihf.ch/Statistic/api/cms/cache300?alias=results&searchQuery=1,8,10,11//1,2,4,5,8,9,20,47,48,49,50,90,81&filterQuery=2017/2/2204/09.09.2016-12.02.2017/102129&filterBy=Season,League,Phase,Date&orderBy=date&orderByDescending=false&take=50&callback=externalStatisticsCallback&skip=-1&language=de", "NLB 16/17"
		# 		fetch_matches "http://dvdata.sihf.ch/Statistic/api/cms/table?alias=results&searchQuery=2//1,2,4,5&filterQuery=2017/2/29.07.2016-06.09.2016/102129&filterBy=Season,League,Date&orderBy=date&orderByDescending=false&take=20&callback=externalStatisticsCallback&skip=-1&language=de", "Vorbereitung"
		# 	    FetchMatchesJob.perform_in(schedule.matches_interval)
		# 	end
		# end
		get_details(1)
	end
  end

  private
  		def fetch_matches(url, competition)
  			require 'net/http'
			require 'json'
			uri = URI(url)
			response = Net::HTTP.get(uri)
			response.slice!("externalStatisticsCallback(")
			response.slice!(");")
			json = JSON.parse(response)
			games = json["data"]
			puts games[0]

			puts games.size
			games.each do |g|
				nl_id = g[9]["gameId"]
				match = nil

				if(Match.exists?(:nl_id => nl_id))
					match = Match.find_by nl_id: nl_id
				else
					match = Match.new
				end
				match.datetime = "#{g[1]} #{g[2]}"
				match.home_team = g[3]["name"]
				match.away_team = g[4]["name"]
				match.nl_id = nl_id
				match.competition = competition
				# Scores
				scoresHome = g[6]["homeTeam"]
				if(scoresHome.size > 1)
					match.h1 = scoresHome[0]
					match.h2 = scoresHome[1]
					match.h3 = scoresHome[2]
					if(scoresHome.size == 4)
						match.h_ot = scoresHome[3]
					end
				end
				puts g[6]
				scoresAway = g[6]["awayTeam"]
				puts scoresAway
				if(scoresAway.size > 1)
					match.a1 = scoresAway[0]
					match.a2 = scoresAway[1]
					match.a3 = scoresAway[2]
					if(scoresHome.size == 4)
						match.a_ot = scoresAway[3]
					end
				end
				match.save
			end
		end

		# 
		def get_details(id)
			require 'net/http'
			require 'json'
			uri = URI("http://dvdata.sihf.ch/statistic/api/cms/gameoverview?alias=gameDetail&searchQuery=20176105000015&callback=externalStatisticsCallback&language=de")
			response = Net::HTTP.get(uri)
			response.slice!("externalStatisticsCallback(")
			response.slice!(");")
			json = JSON.parse(response)

			status = json["status"]["name"]
			if(status != "Ende")
				FetchMatchesJob.perform_in(60)
				puts "#{json["result"]["homeTeam"]} : #{json["result"]["awayTeam"]}"
				puts status
			else
				puts " ---------------------Game is over -----------------------"
			end
		end
 end