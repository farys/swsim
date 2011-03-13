class Project::InfoController < Project::ApplicationController
  def show
    title_t :show
  end

  def update
    if @project.update_attributes(params[:project])
      flash_t :success
      redirect_to @user
    end
  end
end