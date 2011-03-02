class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    @title = 'Projekty'
    @projects = Project.all.paginate :per_page => 15, :page => params[:page]
  end
end