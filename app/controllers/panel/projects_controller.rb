class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    @projects = Project.find(current_user.project_ids).paginate :per_page => 15, :page => params[:page]
  end
end