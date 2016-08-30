class FetchMatchesJob < ActiveJob::Base
  include SuckerPunch::Job
  URL = "http://www.ehco.ch/de/playingschedule---0--0--0--1.html"

  def perform(*args)
  	ActiveRecord::Base.connection_pool.with_connection do
  		if(Schedule.count > 0)
	  		schedule = Schedule.find(1)
	  		if(schedule.matches_running)
	  			puts "------------------------ Scheduled job started: Fetching matches"	
	  			
	  			fetch_matches "http://dvdata.sihf.ch/Statistic/api/cms/cache300?alias=results&searchQuery=1,8,10,11//1,2,4,5,8,9,20,47,48,49,50,90,81&filterQuery=2017/2/2204/09.09.2016-12.02.2017/102129&filterBy=Season,League,Phase,Date&orderBy=date&orderByDescending=false&take=50&callback=externalStatisticsCallback&skip=-1&language=de", "NLB 16/17"
				fetch_matches "http://dvdata.sihf.ch/Statistic/api/cms/table?alias=results&searchQuery=2//1,2,4,5&filterQuery=2017/2/29.07.2016-06.09.2016/102129&filterBy=Season,League,Date&orderBy=date&orderByDescending=false&take=20&callback=externalStatisticsCallback&skip=-1&language=de", "Vorbereitung"
			    FetchMatchesJob.perform_in(schedule.matches_interval)
			end
		end
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
				match = Match.new
				match.datetime = "#{g[1]} #{g[2]}"
				match.home_team = g[3]["name"]
				match.away_team = g[4]["name"]
				match.competition = competition
				match.nl_id = g[9]["gameId"]
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
	  	def fetch_matches2
			require 'open-uri'
			trigger = false
			game_trigger = false
			competition = ""
			cache_match = Match.new

			file = open(URL)
			contents = file.readlines
			contents.each do |line|
				unless trigger
					if line.include? "<h1>Spielplan 1.Mannschaft<\/h1>"
						trigger = true;
					end
				else 
					unless game_trigger
						if line.include? "<h2>Meisterschaftsspiel</h2>"
							competition = "NLB 16/17"
						elsif line.include? "<h2>Vorbereitungsspiel</h2>"
							competition = "Vorbereitung"
						elsif line.include? "<h2>CH-Cup"
							competition = "Cup 2016"
						elsif line =~  /<tr class="skytablerow([2-9]|\d{2,}).+">/
							game_trigger = true
						end
					else
						if line =~ /<td class="skytablefirstcol skytablecol.+/
							cache_match.datetime = extract_date line
						elsif line =~ /<td class="skytablecol2 skytableevencol+./
							cache_match.home_team = line.slice(/[A-Z][\w\s-]+/)
						elsif line =~ /<td class="skytablecol3  skytableoddcol+./
							cache_match.away_team = line.slice(/[A-Z][\w\s-]+/)
							match = Match.create(home_team: cache_match.home_team, away_team: cache_match.away_team, datetime: cache_match.datetime, competition: competition)
							game_trigger = false
						elsif line.include? "</table>"
							trigger = false
						end
					end
				end
			end
		end

		def extract_date(line)
			date = line.slice(/[0-3][0-9]\.[0-3][0-9]\.1[0-9]{1}/)
			date = date[0, date.length - 2] + "20" + date[date.length - 2, 2]
			time = line.slice(/[0-2][0-9]:[0-5][0-9]/)
			date = date + " " + time
		end 

		def get_details(id)
			require 'net/http'
			require 'json'
			uri = URI("http://dvdata.sihf.ch/statistic/api/cms/gameoverview?alias=gameDetail&searchQuery=#{id}&callback=externalStatisticsCallback&language=de")
			response = Net::HTTP.get(uri)
			response.slice!("externalStatisticsCallback(")
			response.slice!(");")
			json = JSON.parse(response)

			puts json["details"]["homeTeam"]["name"]
			puts json["details"]["awayTeam"]["name"]
			scores = json["result"]["scores"]
			scores.each{ |s|
				puts "#{s["homeTeam"]}:#{s["awayTeam"]}"
			}

			periods = json["summary"]["periods"]
			periods.each{ |p|
				goals = p["goals"]
				puts goals.size
			}
		end
 end