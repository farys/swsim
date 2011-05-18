class BonuspointsController < ApplicationController
	def index
	  	@title = "Punkty bonusowe"
	  	@user = User.find(params[:user_id])
	  	@bonuspoints = @user.bonuspoints.paginate(:page => params[:page])
  	end
  	
  	def addfromblog
  		@user_id = params[:user_id]
  		Bonuspoint.use!(20, @user_id, 1)
  		redirect_to :back
  	end
end
