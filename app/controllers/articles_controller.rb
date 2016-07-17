class ArticlesController < ApplicationController

	def index
		@articles = Article.limit(5).offset(params[:offset]).order("date DESC")
		render :json => @articles, :except=>[:news_image_file_size, :news_image_updated_at, :news_image_content_type, :updated_at, :created_at, ]
	end

  	def show
    	@article = Article.find(params[:id])
    	render :json => @article
  	end

	def new
		@article = Article.new
	end
	
	def create
		@article = Article.new(article_params)
		if @article.save
			puts "----------------- Saving successful"
			send_notification
			redirect_to @article
		else
			render 'new'
		end
	end

  	private
		def article_params
			params.require(:article).permit(:title, :text, :url, :date)	
		end

		def send_notification
			require 'net/http'
			require 'net/https'
			require 'uri'

			puts "----------------- Trying to send notification"

			uri = URI.parse("https://fcm.googleapis.com/fcm/send")
			https = Net::HTTP.new(uri.host,uri.port)
			https.use_ssl = true
			request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AIzaSyBaLCHWTBUrRa_h5AeXjBYcfz3OIz7q8iE'})

			@to_send = { 
				"to" => "/topics/news",
				"notification" => {
					"title" => "Testmessage",
					"body" => "Teesswdakjlhfg"
				}
			}.to_json

			request.body = "[ #{@to_send} ]"
			puts @to_send

			puts "----------------- send notification"
			res = https.request(request)
			puts "Response #{res.code} #{res.message}: #{res.body}"
		end
end