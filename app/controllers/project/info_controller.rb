class Project::InfoController < Project::ApplicationController
	before_filter :check_privileges, :only => :update
	
  def show
    title_t :show
  end
  
  #zakonczenie projektu lub edycja opisu
  def update
  	if params[:project].nil? && 
  	   @project.owner_id == current_user.id && 
  	   @project.active?
	  	@project.status = Project::STATUSES[:finished]
	  	if @project.save
        @comment = Comment.create_from_project_for_owner(@project)
	      redirect_to edit_panel_comment_path(@comment)
        flash_t :notice, :finishing_update
	    else
	      title_t :show
	      render :show
	    end
  	else
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
  
  private
  
  def check_privileges
  	unless can_edit?('info')
  	  flash_t_general :error, 'error.privileges'
  		redirect_to project_info_path
  	end
  end
end
