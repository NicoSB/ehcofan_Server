class WelcomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "er34sie"
  def index
  	@schedule = Schedule.find(1)
  end
end
