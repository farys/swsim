class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    @projects = Project.all.paginate :per_page => 15, :page => params[:page]
  end
end