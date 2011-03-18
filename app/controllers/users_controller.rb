class UsersController < ApplicationController
	before_filter :correct_user, :only => [:edit, :update]
	
	$countries = Carmen.countries
	
	def new
		@user = User.new
	end
	
	def show
      @user = User.find(params[:id])
      @country_name = Carmen::country_name(@user.country)
      @country_flag = "flags/#{@user.country.downcase}.gif"
      #country_flag = "http://www.flagsofallcountries.com/0/#{@user.country.downcase}.gif"
    end
	
	def create
    	@user = User.new(params[:user])
    	if validate_recap(params, @user.errors) && @user.save
    		redirect_to root_path
      		flash_t :notice
    	else
      		render :action => :new
    	end
  	end
  	
  	def edit
  		@user = User.find(params[:id])
  	end
  	
  	def update
  		@user = User.find(params[:id])
    	if params[:user][:password] == ''	
    		params[:user][:password] = @user.password
    		params[:user][:password_confirmation] = @user.password
    	end
	    if @user.update_attributes(params[:user])
	      redirect_to @user
	      flash_t :notice
	    else
	      @title = "Edit user"
	      render :action => :edit
	    end
    end
  	
  	private
  	
  	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end