class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    @title = 'Projekty'
    @projects = Project.all
  end
end