class MatchesController < ApplicationController
	http_basic_authenticate_with name: "admin", password: ENV['ADMIN_PW'], except: [:index]

	def index
		if(params[:mode] != nil && params[:mode] == "control")
			@matches = Match.all
		else	
			if(params[:updated_at] != nil)
				query = "updated_at > :last_updated", {last_updated: params[:updated_at]}
				@matches = Match.where(query).order("datetime ASC")
			else
				@matches = Match.all.order("datetime ASC")
			end
			render :json => @matches
		end
	end

  	def show
    	@match = Match.find(params[:id])
    	render :json => @match
  	end

	def new
		@match = Match.new
	end

	def edit
  		@match = Match.find(params[:id])
	end
	
	def create
		@match = Match.new(match_params)
		if @match.save
			redirect_to @match
		else
			render 'new'
		end
	end

	def update
		@match = Match.find(params[:id])
		if @match.update(match_params)
		  redirect_to @match
		else
		  render 'edit'
		end
	end

	def destroy
		@match = Match.find(params[:id])
		@match.destroy

		redirect_to matches_path(mode: "control")
	end

	private
		def match_params
			params.require(:match).permit(:home_team, :away_team, :datetime, :competition, :h1, :h2, :h3, :h_ot, :a1, :a2, :a3, :a_ot, :nl_id, :active, :status)	
		end
end
