class Project::ApplicationController < ApplicationController
  before_filter :login_required, :get_project
  
  def get_project
    @project = Project.find(params[:id])
    if @project.member?(@logged_user.id) == false
      flash_t :notice
      redirect_to :controller => '/panel/projects', :action => :index
    end
  end
end