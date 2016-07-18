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
			redirect_to @article
		else
			render 'new'
		end
	end

	private
		def article_params
			params.require(:article).permit(:title, :text, :url, :date)	
		end
end