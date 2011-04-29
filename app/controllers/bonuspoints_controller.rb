class BonuspointsController < ApplicationController
	def index
	  	@title = "Punkty bonusowe"
	  	@user = User.find(params[:user_id])
	  	@bonuspoints = @user.bonuspoints.paginate(:page => params[:page])
  	end
	
	def add
		@points = params[:points]
		@user_id = params[:user_id]
		@for_what = params[:for_what]
		BonusPoints.create!(:points => @points, :user_id => @user_id, :for_what => @for_what)
	end
end