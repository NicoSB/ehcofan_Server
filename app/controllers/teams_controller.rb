class TeamsController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "er34sie", except: [:index]

	def index
		if(params[:mode] != nil && params[:mode] == "control")
			@teams = Team.all
		else
			@teams = Team.where(competition: params[:competition]).order("teams.group ASC, wins*3 + ot_wins*2 + ot_losses DESC, goals_for - goals_against DESC , goals_for DESC")
			render :json => @teams, :except=>[:updated_at, :created_at]
		end
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

	def destroy
		@team = Team.find(params[:id])
		@team.destroy

		redirect_to teams_path(mode: "control")
	end

	private
		def team_params
			params.require(:team).permit(:name, :competition, :wins, :ot_wins, :ot_losses, :losses, :goals_for, :goals_against, :group)	
		end
end
