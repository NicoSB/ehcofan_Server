class FetchArticlesJob < ActiveJob::Base
  include SuckerPunch::Job
  queue_as :default
  URL = "http://www.ehco.ch/de/news-_content---1--1.html"

  def perform(*args)
  	ActiveRecord::Base.connection_pool.with_connection do
  		if(Schedule.count > 0)
	  		schedule = Schedule.find(1)
	  		if(schedule.articles_running)
	  			puts "------------------------ Scheduled job started: Fetching articles ------------------------"
			  	fetch_articles
			    FetchArticlesJob.perform_in(schedule.articles_interval)
			end
		end
	end
  end

  private
  	#fetches the articles from the homepage
  	def fetch_articles
		require 'open-uri'
		newest_article = Article.limit(1).order("date DESC")
		news_trigger = false
		title_trigger = false
		articles = Array.new

		file = open(URL)
		contents = file.readlines
		articles = Array.new
		cache_article = nil
		

		contents.each do |line|
			if title_trigger
				cache_article.title = replace_uml line.strip
				cache_article.text = fetch_text cache_article.url
				cache_article.text = replace_uml cache_article.text
				articles.push(cache_article)

				title_trigger = false
				news_trigger = false
			elsif news_trigger
				#Date
				if line =~ /[1-3]?[0-9]\.[0-1]?[0-9]\.201[0-9]{1}/
					cache_article.date = line.slice(/[1-3]?[0-9]\.[0-1]?[0-9]\.201[0-9]{1}/)
					if (newest_article[0] != nil && cache_article.date < newest_article[0].date)
						break
					end
				#Title
				elsif line.include? "box__title"
					title_trigger = true
				#Text
				elsif line.include? ".jpg"
					image_url = "http://www.ehco.ch" + line.downcase.slice(/\/upload\/.+\.jp[e]?g/)
					
					if(image_url != nil)
						cache_article.news_image = URI.parse(image_url)
					end
				#url
				elsif line =~ /\/de\/.+.html/
					cache_article.url = "http://www.ehco.ch" + line.slice(/\/de\/.+.html/)
				end
			elsif line.include? "small-12 columns"
				news_trigger = true					
				cache_article = Article.new
			end
		end

		articles.reverse_each do |a|
			if(!Article.exists?(:url => a.url))
				a.save
				if !a.errors.empty?
					puts a.errors.inspect
				end
			end
		end 
	end
	#fetches the text from the given url
	def fetch_text(article_url)
		require 'open-uri'
		trigger = false
		text = ""
		file = open(article_url)
		contents = file.readlines
		contents.each do |line| 
			if trigger
				if line.include? "<\/div>"
					text = text + line.gsub("<\/div>", "")
					trigger = false
				end
				text = text + line
			elsif line.include? "<div class=\"lead\">"
				trigger = true
				text = text + line.gsub("<div class=\"lead\">", "")
			elsif line.include? "<div class=\"text__content\">"
				trigger = true
				text = text + line.gsub("<div class=\"lead\">", "")
			end
		end
		return text
	end	

	def compare_dates(date1, date2)
		year1 = date1.slice(/201[0-9]/)
		year2 = date2.slice(/201[0-9]/)

		if(year1 != year2)
			return year1 < year2
		else
			if(date1.include? "-")
				month1 = date1[5,2]
				day1 = date1[8,2]
			elsif(date1.include? ".")
				day1 = date1[0, date1.index(".")]
				month1 = date1[date1.index(".") + 1, date1.index(".", 3)]
			end
			if(date2.include? "-")
				month2 = date2[5,2]
				day2 = date2[8,2]
			elsif(date2.include? ".")
				day2 = date2[0, date2.index(".")]
				month2 = date2[date2.index(".") + 2, date2.index(".", 3)]
			end

			if(month1 != month2)
				return month1 < month2
			elsif(day1 != day2)
				return day1 < day2
			else
				return true
			end
		end
	end

	def fetch_image_url(article_url)
		require 'open-uri'
		file = open(article_url)

		contents = file.readlines
		contents.each do |line|
			if line =~ /\s*<img alt=".+" src=".+".+>/
				image_url = line.slice(/\/upload.+[Gg]/)
				if(image_url != nil)
					image_url = "http://www.ehco.ch" + image_url
					return image_url
				end
			end
		end
		puts "couldn't fetch image from: " + article_url
		return nil
	end

	def replace_uml(text)
		text.gsub! "&uuml;", "ü"
		text.gsub! "&auml;", "ä"
		text.gsub! "&ouml;", "ö"
		text.gsub! "&Uuml;", "Ü"
		text.gsub! "&Auml;", "Ä"
		text.gsub! "&Ouml;", "Ö"
		text.gsub! "&euml;", "é"
		text.gsub! "&quot;", "\""
		text.gsub! "&ndash;", "-"
		text.gsub! /&[\w]{2}quo;/, "\""
		return text
	end
end
