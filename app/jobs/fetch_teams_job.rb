class FetchTeamsJob < ActiveJob::Base
	include SuckerPunch::Job
  queue_as :default

  def perform(*args) 
  	if(Schedule != nil && Schedule.count > 0)
	  		schedule = Schedule.find(1)
	  		if(schedule.teams_running)
	  			puts "------------------------ Scheduled job started: Fetching teams -----------------------"
	  			
	  			fetch_teams "http://dvdata.sihf.ch/Statistic/api/cms/cache300?alias=standing&size=L&searchQuery=1//1,2&filterQuery=2016/2/2204&filterBy=Season,League,Phase&orderBy=rank&orderByDescending=false&callback=externalStatisticsCallback&skip=-1&language=de", "NLB 16/17"
			   
			   	FetchMatchesJob.perform_in(schedule.teams_interval)
			end
		end		
	end

	def fetch_teams(uri, competition)
  		require 'net/http'
		require 'json'
		uri = URI(uri)
		response = Net::HTTP.get(uri)
		response.slice!("externalStatisticsCallback(")
		response.slice!(");")
		json = JSON.parse(response)
		teams = json["data"]

		teams.each do |t|
			team = nil
			if(Team.exists?(name: t[1]["name"]))
  				team = Team.find_by(name: t[1]["name"])
  			else
  				team = Team.new
  				team.name = t[1]["name"]
  			end

  			team.wins = t[3]
  			team.ot_wins = t[4] + t[5]
  			team.ot_losses = t[6] + t[7]
  			team.losses = t[8]
  			team.goals_for = t[9]
  			team.goals_against = t[10]
  			team.competition = competition
  			team.save
  		end
  end		
end
