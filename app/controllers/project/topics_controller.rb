class Project::TopicsController < Project::ApplicationController
	before_filter :edit_topic, :only => [:edit, :destroy, :update]
	
	def index
		title_t :index
		@topics = @project.topics
	end
	
	def show
	  unless Topic.exists? params[:id]
	    flash_t_general :error, 'topic.dont_exists'
	    redirect_to project_topics_path
	    return
	  end
	  
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
		
		if topic.save
			flash_t :success
			redirect_to project_topics_path
		else
		  title_t :new
			render :action => :new
		end
	end
	
	def edit
	  title_t :edit	    
	  @topic = Topic.find(params[:id])	  
	end
	
	def update
	  topic = Topic.find(params[:topic][:id])
	  topic.title = params[:topic][:title]
		topic.content = params[:topic][:content]
		
		if topic.save
		  flash_t :success
		  redirect_to project_topics_path
		else
		  title_t :edit
		  render :action => :edit
		end
	end
	
	def destroy	  
		topic = Topic.find(params[:id])
		if edit_topic? topic
			if topic.destroy
				flash_t :success
			else
			  flash_t_general :error, 'error.unknown'
			end
		end
		redirect_to project_topics_path
	end
	
	private
	
	#sprawdzenie uprawnie do edycji tematow
  def edit_topic
    unless Topic.exists? params[:id]
	    flash_t_general :error, 'topic.dont_exists'
	    redirect_to project_topics_path
	    return
	  end
	  
  	if can_edit?('forum')
  		true
  	elsif current_user.topic_ids.include?(params[:id]) && @project.active?
  		true
  	else
  		false
  	end
  end  
end
