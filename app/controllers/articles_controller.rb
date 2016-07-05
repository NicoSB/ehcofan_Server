class ArticlesController < ApplicationController

	def index
		@articles = Article.limit(5).offset(params[:offset]).order("date DESC")
		render :json => @articles 	
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