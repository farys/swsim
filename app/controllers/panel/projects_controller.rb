class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    title_t :index
    @projects = current_user.projects.paginate :per_page => 15,
    																					 :page => params[:page]
  end
end