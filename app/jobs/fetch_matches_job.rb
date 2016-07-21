class FetchMatchesJob < ActiveJob::Base
  include SuckerPunch::Job
  URL = "http://www.ehco.ch/de/playingschedule---0--0--0--1.html"

  def perform(*args)
  	ActiveRecord::Base.connection_pool.with_connection do
  		if(Schedule.count > 0)
	  		schedule = Schedule.find(1)
	  		if(schedule.matches_running)
	  			puts "------------------------ Scheduled job started: Fetching matches"
			  	fetch_matches
			    FetchMatchesJob.perform_in(schedule.matches_interval)
			end
		end
	end
  end

  private
	  def fetch_matches
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
							puts cache_match.home_team + "  " + cache_match.away_team + "  " + cache_match.datetime.strftime("%d.%m.%Y")
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
 end