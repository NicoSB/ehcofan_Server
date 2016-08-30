class SchedulesController < ApplicationController
	def index
		if Schedule.count == 0
			redirect_to action: "new"
		else
			redirect_to action: "edit", id: 1
		end
	end

	def show
    	@schedule = Schedule.find(params[:id])
  	end

	def new
		@schedule = Schedule.new
	end

	def edit
  		@schedule = Schedule.find(params[:id])
	end

	def create
		if(Schedule.count > 0)
			redirect_to action: "index"
		else
			@schedule = Schedule.new(schedule_params)
			if @schedule.save
				FetchArticlesJob.perform_async()
				FetchMatchesJob.perform_async()
				redirect_to action: "index"
			else
				render 'new'
			end
		end
	end

	def update
		@schedule = Schedule.find(params[:id])
		if @schedule.update(schedule_params)
			if @schedule.articles_running = true
				FetchArticlesJob.perform_async()
			end
			if @schedule.matches_running = true
				FetchMatchesJob.perform_async()
			end
		  redirect_to action: "index"
		else
		  render 'edit'
		end
	end

  	private
		def schedule_params
			params.require(:schedule).permit(:articles_running, :articles_interval, :matches_running, :matches_interval, match_urls: [])	
		end
end
