class Project::ApplicationController < ApplicationController	
  before_filter :get_project
    
  def can_edit?(page)
  	if @project.active?
	  	case page
	  		when 'info'
	  			@project.user_role(current_user.id).info
	  		when 'user'
	  			@project.user_role(current_user.id).user
	  		when 'forum'
	  			@project.user_role(current_user.id).forum
	  		when 'file'
	  			@project.user_role(current_user.id).file	
	  	end
	  else
	  	false
  	end
  end
  
  private
  def get_project
    @project = Project.find(params[:project_id])
    unless @project.member?(current_user.id)
      flash_t :notice
      redirect_to :controller => '/panel/projects', :action => :index
    end
    @members = @project.users   
  end
end