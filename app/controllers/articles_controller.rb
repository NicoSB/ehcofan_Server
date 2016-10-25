class ArticlesController < ApplicationController
	http_basic_authenticate_with name: "admin", password: ENV['ADMIN_PW'], except: [:index]

	def index
		if(params[:mode] != nil && params[:mode] == "control")
			@articles = Article.all
		else
			limit = 5
			if(params[:limit] != nil)
				limit = params[:limit]
			end
			@articles = Article.limit(limit).offset(params[:offset]).order("date DESC, id DESC")
			render :json => @articles, :except=>[:news_image_file_size, :news_image_updated_at, :news_image_content_type, :updated_at, :created_at]
		end
	end

  	def show
    	@article = Article.find(params[:id])
    	render :json => @article
  	end

	def new
		@article = Article.new
	end

	def edit
  		@article = Article.find(params[:id])
	end
	
	def create
		@article = Article.new(article_params)
		if @article.save
			redirect_to @article
		else
			render 'new'
		end
	end

	def update
		@article = Article.find(params[:id])
		if @article.update(article_params)
		  redirect_to @article
		else
		  render 'edit'
		end
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy

		redirect_to articles_path(mode: "control")
	end

	private
		def article_params
			params.require(:article).permit(:title, :text, :url, :date)	
		end
end