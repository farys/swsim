class Project::InfoController < Project::ApplicationController
  def show
    title_t :show
  end

  def update
    @project.description = params[:project][:description]
    if @project.save
      flash_t :success
      redirect_to project_info_path(@project)
    else
      title_t :show
      render :show
    end
  end
  
  def finish
  	if @project.leader_id == current_user.id && @project.status == Project::STATUSES[:active]
  		@project.status = Project::STATUSES[:verification]
  		@project.save
  		render :show
  	end
  end
end