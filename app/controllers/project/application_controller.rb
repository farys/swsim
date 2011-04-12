class Project::ApplicationController < ApplicationController	
  before_filter :get_project
  
  #sprawdzenie uprawnien do edytowania wybranego widoku  
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
	  	flash_t_general :notice, 'project.not_active'
	  	redirect_to project_info_path(@project)
  	end
  end
  
  private
  
  #autoryzacja uzytkownika jako czlonka projektu
  def get_project
       
    unless Project.exists? params[:project_id]
      flash_t_general :error, 'project.dont_exists'
      redirect_to panel_projects_path
      return
    end
    
    @project = Project.find(params[:project_id])
    
    unless @project.member?(current_user.id)
      flash_t_general :error, 'project.not_participating'
      redirect_to panel_projects_path
      return
    end
    
    @members = @project.users.paginate :per_page => 15, :page => params[:page]
  end
end
