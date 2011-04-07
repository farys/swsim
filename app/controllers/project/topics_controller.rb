class Project::TopicsController < Project::ApplicationController
	
	def index
		title_t :index
		@topics = @project.topics
	end
	
	def show
		@topic = Topic.find(params[:id])
		@posts = @topic.posts
		title_t :show
	end
	
	def new
		@topic = Topic.new
		title_t :new
	end
	
	def create
		topic = Topic.new
		topic.project_id = @project.id
		topic.user_id = current_user.id
		topic.title = params[:topic][:title]
		topic.content = params[:topic][:content]
		if @project.active?
			if topic.save
				flash_t :success
				redirect_to project_topics_path
			else
				redirect_to :action => :new
			end
		end
	end
	
	def destroy
		topic = Topic.find(params[:id])
		if edit_topic? topic
			if topic.destroy
				flash_t :success
			end
		end
		redirect_to project_topics_path
	end
end
