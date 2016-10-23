class WelcomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: ENV['ADMIN_PW']
  def index
  	if Schedule.count > 0
  		@schedule = Schedule.find(1)
  	else
  		redirect_to schedules_url
  	end
  end
end
