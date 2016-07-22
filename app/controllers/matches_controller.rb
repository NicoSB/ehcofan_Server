class MatchesController < ApplicationController
	def index
		if(params[:competition] != nil)
			@matches = Match.where(competition: params[:competition]).order("datetime ASC")
		else
			@matches = Match.order("datetime ASC")
		end
		render :json => @matches, :except => [:updated_at]
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


	private
		def match_params
			params.require(:match).permit(:home_team, :away_team, :datetime, :competition, :h1, :h2, :h3, :h_ot, :a1, :a2, :a3, :a_ot)	
		end
end
