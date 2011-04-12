class Project::FilesController < Project::ApplicationController
  before_filter :check_read_privileges, :except => [:index, :new, :create]
	before_filter :check_edit_privileges, :except => [:index, :show]
	
	def index
		title_t :index
		@files = @project.project_files.paginate :per_page => 15,
		                                         :page => params[:page]
	end
	
	def show	  
		@file = ProjectFile.find(params[:id])
		title_t :show
	end
	
	def new
		@file = ProjectFile.new()
		title_t :new	
	end
	
	def create
		@file = ProjectFile.new(params[:project_file])
		@file.project_id = @project.id
		
		if @file.save
			flash_t :success
			redirect_to project_files_path
		else
			title_t :new
			render :action => :new
		end
	end
	
	def update  
		@file = ProjectFile.find(params[:id])
		@file.description = params[:project_file][:description]
		
		if @file.save
			flash_t :success
			redirect_to project_file_path(@project, @file)
		else
			title_t :show
			render :show
		end
	end
	
	def destroy 
		file = ProjectFile.find(params[:id])
		if file.destroy
			flash_t :success
		end
		redirect_to project_files_path
	end
	
	private
	
	def check_edit_privileges
		unless can_edit? 'file'
			flash_t_general :error, 'error.privileges'
			redirect_to project_files_path
		end
	end
	
	def check_read_privileges
	  unless ProjectFile.exists? params[:id]
	    flash_t_general :error, 'project_file.dont_exists'
	    redirect_to project_files_path
	    return
	  end
	  
	  unless @project.project_file_ids.include?(params[:id].to_i)
	    flash_t_general :error, 'project_file.not_included'
	    redirect_to project_files_path
	  end
	end
end
