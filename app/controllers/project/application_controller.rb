class Project::ApplicationController < ApplicationController	
  before_filter :get_project
  
  def get_project
    @project = Project.find(params[:id])
    unless @project.member?(current_user.id)
      flash_t :notice
      redirect_to :controller => '/panel/projects', :action => :index
    end
    @members = @project.users
  end
  
  def can_edit?(page)
    "#{@project.user_role(current_user.id)}.#{page}"
  end
end