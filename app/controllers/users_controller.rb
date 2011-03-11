class UsersController < ApplicationController
	
	def new
		@user = User.new
		@countries = Carmen.countries
	end
	
	def create
		@countries = Carmen.countries
    	@user = User.new(params[:user])
    	if @user.save
    		redirect_to root_path
      		flash_t :notice
    	else
      		render :action => :new
    	end
  	end
end