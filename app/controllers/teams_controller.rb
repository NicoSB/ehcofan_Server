class TeamsController < ApplicationController
	def index
		@teams = Team.where(competition: params[:competition]).order("group DESC, wins*3 + ot_wins*2 + ot_losses DESC, goals_for - goals_against DESC , goals_for DESC")
		render :json => @teams, :except=>[:updated_at, :created_at]
	end

  	def show
    	@team = Team.find(params[:id])
    	render :json => @team
  	end

	def new
		@team = Team.new
	end

	def edit
  		@team = Team.find(params[:id])
	end
	
	def create
		@team = Team.new(team_params)
		if @team.save
			redirect_to @team
		else
			render 'new'
		end
	end

	def update
		@team = Team.find(params[:id])
		if @team.update(team_params)
		  redirect_to @team
		else
		  render 'edit'
		end
	end


	private
		def team_params
			params.require(:team).permit(:name, :competition, :wins, :ot_wins, :ot_losses, :losses, :goals_for, :goals_against, :group)	
		end
end
