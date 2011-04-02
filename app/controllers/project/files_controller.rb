class Project::FilesController < Project::ApplicationController
	def index
		title_t :index
		@files = @project.project_files
	end
	
	def show
		@file = ProjectFile.find(params[:id])
		title_t :show
	end
	
	def update
		redirect_to project_files_path
	end
end