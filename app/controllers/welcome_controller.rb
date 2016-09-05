class WelcomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: ENV['ADMIN_PW']
  def index
  	@schedule = Schedule.find(1)
  end
end
