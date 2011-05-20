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
  		@rightuser = Blogpost.find_by_id(@blog)
  		if @rightuser.user_id.to_i == @user_id.to_i
  			Useful.use!(@blog, @us)
  			Bonuspoint.use!(20, @user_id, 1)
  			flash[:success] = "Autor wpisu otrzymal od Ciebie punkty bonusowe"
  			redirect_to :back
  		else
  			flash[:error] = "Ten uzytkownik nie jest wlascicielem wpisu"
  			redirect_to root_path
  		end
  	end
end
