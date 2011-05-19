class BonuspointsController < ApplicationController
	def index
	  	@title = "Punkty bonusowe"
	  	@user = User.find(params[:user_id])
	  	@bonuspoints = @user.bonuspoints.paginate(:page => params[:page])
  	end
  	
  	def addfromblog
  		@user_id = params[:user_id]
  		@us = current_user.id
  		@blog = params[:id]
  		Useful.use!(@blog, @us)
  		Bonuspoint.use!(20, @user_id, 1)
  		flash[:success] = "Autor wpisu otrzymal od Ciebie punkty bonusowe"
  		redirect_to :back
  	end
end
