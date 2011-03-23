class Project::InfoController < Project::ApplicationController
  def show
    title_t :show
  end

  def update
  	if params[:project].nil? && @project.owner_id == current_user.id && @project.active?
	  	@project.status = Project::STATUSES[:finished]
	  	if @project.save
        Comment.create_from_project(@project)
	      redirect_to panel_comments_path
	    else
	      title_t :show
	      render :show
	    end
  	elsif @project.active? && can_edit?('info')
	    @project.description = params[:project][:description]
	    if @project.save
	      flash_t :success
	      redirect_to project_info_path(@project)
	    else
	      title_t :show
	      render :show
	    end
    end
  end
end