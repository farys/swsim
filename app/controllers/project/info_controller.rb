class Project::InfoController < Project::ApplicationController
  def show
    title_t :show
  end

  def update
  	if params[:project].nil? && @project.owner_id == current_user.id && @project.active?
	  	@project.status = Project::STATUSES[:finished]
	  	if @project.save
        @comment = Comment.create_from_project_for_owner(@project)
	      redirect_to edit_panel_comment_path(@comment), :notice => t("flash.project.info.finishing_update")
	    else
	      title_t :show
	      render :show
	    end
  	elsif can_edit?('info')
	    @project.description = params[:project][:description]
	    if @project.save
	      flash_t :success
	      redirect_to project_info_path
	    else
	      title_t :show
	      render :show
	    end
    end
  end
end