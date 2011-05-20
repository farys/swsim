class Project::ApplicationController < ApplicationController
  before_filter :get_project
  before_filter :check_membership, :except =>[:accept, :reject]
  before_filter :project_active, :except => [:show, :index]
  
  #sprawdzenie uprawnien do edytowania wybranego elementu 
  def can_edit?(page)
    role = Hash.new(false)
    role.merge! @project.user_role(current_user.id).attributes
    role[page]
  end
  
  private
  
  #pobranie projektu
  def get_project      
    unless Project.exists? params[:project_id]
      flash_t_general :error, 'project.dont_exists'
      redirect_to panel_projects_path
      return
    end
        
    @project = Project.find(params[:project_id])
  end
  
  #autoryzacja uzytkownika jako czlonka projektu
  def check_membership
    unless @project.member?(current_user.id)
      flash_t_general :error, 'project.not_participating'
      redirect_to panel_projects_path
      return
    end    
  end
  
  def project_active
    unless @project.active?
      flash_t_general :notice, 'project.not_active'
	  	redirect_to project_info_path(@project)
    end
  end
end
