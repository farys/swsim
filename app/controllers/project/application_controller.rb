class Project::ApplicationController < ApplicationController	
  before_filter :get_project
  before_filter :check_membership, :except =>[:accept, :reject]
  
  #sprawdzenie uprawnien do edytowania wybranego widoku  
  def can_edit?(page)
    if @project.active?
	  	case page
	  		when 'info'
	  		  @project.user_role(current_user.id).info
	  		when 'invitation'
	  		  @project.user_role(current_user.id).invitation	
	  		when 'member'
	  		  @project.user_role(current_user.id).member
	  		when 'ticket'
	  		  @project.user_role(current_user.id).ticket
	  		when 'forum'
	  		  @project.user_role(current_user.id).forum
	  		when 'file'
	  		  @project.user_role(current_user.id).file
	  		else
	  		  false	
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
  end
  
  def check_membership
    unless @project.member?(current_user.id)
      flash_t_general :error, 'project.not_participating'
      redirect_to panel_projects_path
      return
    end    
  end
end
