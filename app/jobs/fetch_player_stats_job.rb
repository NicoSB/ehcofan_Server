class FetchPlayerStatsJob < ActiveJob::Base
	include SuckerPunch::Job
  queue_as :default

  def perform(*args)
		puts "------------------------ Scheduled job started: Fetching stats ------------------------"	
		uri = URI("http://dvdata.sihf.ch/Statistic/api/cms/cache300?alias=player&searchQuery=1,11//1,2,90&filterQuery=2016/2/1881/102129&filterBy=Season,League,Phase&orderBy=points&orderByDescending=true&take=50&callback=externalStatisticsCallback&skip=-1&language=de")
		response = Net::HTTP.get(uri)
		response.slice!("externalStatisticsCallback(")
		response.slice!(");")

		json = JSON.parse(response)
		players = json["data"]

		players.each do |p|
			player = Player.where("surname || ' ' || name = '#{p[1]}'").take
			if(player != nil)
				player.games = p[4]
				player.goals = p[5]
				player.assists = p[6]
				player.pim = p[9]
				player.save
			end
		end
  end
end
