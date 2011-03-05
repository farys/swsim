class Project::InfoController < Project::ApplicationController
  def show
    @project = Project.find(params[:id])
  end
end