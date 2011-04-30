class PortfoliosController < ApplicationController
	
	def index
	  	@title = "Portfolio"
	  	@user = User.find(params[:user_id])
	  	@portfolio = @user.projects.where(:status => 1).paginate :per_page => 15, :page => params[:page]
  	end
end