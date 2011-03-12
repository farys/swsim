class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    title_t :index
    @projects = Project.find(@logged_user.project_ids).paginate :per_page => 15, :page => params[:page]
  end
end