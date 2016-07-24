class PlayersController < ApplicationController
	def index
		@players = Player.order("position != 'Torhüter', position != 'Verteidiger', position != 'Stürmer', number ASC")
		render :json => @players, :except=>[:updated_at, :created_at]
	end

  	def show
    	@player = Player.find(params[:id])
    	render :json => @player
  	end

	def new
		@player = Player.new
	end

	def edit
  		@player = Player.find(params[:id])
	end
	
	def create
		@player = Player.new(player_params)
		if @player.save
			redirect_to @player
		else
			render 'new'
		end
	end

	def update
		@player = Player.find(params[:id])
		if @player.update(player_params)
		  redirect_to @player
		else
		  render 'edit'
		end
	end


	private
		def player_params
			params.require(:player).permit(:name, :surname, :position, :number, :birthdate, :nationality, :weight, :height, :ep_id, :contract)	
		end
end
