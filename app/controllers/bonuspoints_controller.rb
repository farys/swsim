class BonuspointsController < ApplicationController
	def index
	  	@title = "Punkty bonusowe"
	  	@user = User.find(params[:user_id])
	  	@bonuspoints = @user.bonuspoints.paginate(:page => params[:page])
  	end
  	
  	def addfromblog
  		@user_id = params[:user_id]
  		Bonuspoint.create!(:points => 20, :user_id => @user_id, :for_what => 1)
  		redirect_to user_blogposts_path(@user_id)
  	end
end