class PlayersController < ApplicationController
	http_basic_authenticate_with name: "admin", password: ENV['ADMIN_PW'], except: [:index]

	def index
		if(params[:mode] != nil && params[:mode] == "control")
			@players = Player.all
		else
			if(params[:updated_at] != nil && params[:updated_at] != "")
				@players = Player.where("updated_at > :last_updated", {last_updated: params[:updated_at]})
			else
				@players = Player.order("position != 'Torhüter', position != 'Verteidiger', position != 'Stürmer', number ASC")
			end
			render :json => @players, :except=>[:created_at, :player_image_content_type, :player_image_file_size, :player_image_updated_at]
		end
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

	def destroy
		@player = Player.find(params[:id])
		@player.destroy

		redirect_to players_path(mode: "control")
	end

	private
		def player_params
			#comment
			params.require(:player).permit(:name, :surname, :position, :number, :birthdate, :nationality, :weight, :height, :ep_id, :contract, :active, :player_image)	
		end
end
