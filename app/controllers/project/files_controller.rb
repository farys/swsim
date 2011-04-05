class Project::FilesController < Project::ApplicationController
	before_filter :check_privileges, :except => [:index, :show]
	
	def index
		title_t :index
		@files = @project.project_files
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
		if ProjectFile.create(params[:project_file])
			flash_t :success
			redirect_to project_files_path
		else
			title_t :new
			render :action => :new
		end
	end
	
	def update
		file = ProjectFile.find(params[:id])
		file.description = params[:project_file][:description]
		if file.save
			flash_t :success
			redirect_to project_file_path(@project, file)
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
	
	def check_privileges
		unless can_edit? 'file'
			redirect_to project_files_path
		end
	end
end