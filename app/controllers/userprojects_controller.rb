class UserprojectsController < ApplicationController
	
  def index
    @user = User.find(params[:user_id])
    @title = "#{@user.name} #{@user.lastname} || Aktywne projekty"
    @projects = @user.projects.where(:status => 0).paginate :per_page => 15, :page => params[:page]
  end
  
end