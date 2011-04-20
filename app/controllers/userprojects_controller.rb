class UserprojectsController < ApplicationController
	
  def index
    @title = "Aktywne projekty"
    @user = User.find(params[:user_id])
    @projects = @user.projects.paginate :per_page => 15, :page => params[:page]
  end
  
end