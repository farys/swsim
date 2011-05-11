class PortfoliosController < ApplicationController
	
	def index
	  	@user = User.find(params[:user_id])
	  	@title = "#{@user.name} #{@user.lastname} || Portfolio"
	  	@portfolio = @user.projects.where(:status => 1).paginate :per_page => 15, :page => params[:page]
  	end
end