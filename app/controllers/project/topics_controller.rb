class Project::TopicsController < Project::ApplicationController
  before_filter :get_topic, :except => [:index, :new, :create]
	before_filter :can_edit, :only => [:edit, :destroy, :update]
	
	def index
		title_t :index
		@topics = @project.topics.paginate :per_page => 10,
    																	 :page => params[:page]
	end
	
	def show  
		@posts = @topic.posts
		title_t :show
	end
	
	def new
		@topic = Topic.new
		title_t :new
	end
	
	def create	  
		@topic = Topic.new
		@topic.project_id = @project.id
		@topic.user_id = current_user.id
		@topic.title = params[:topic][:title]
		@topic.content = params[:topic][:content]
		
		if @topic.save
			flash_t :success
			redirect_to project_topics_path
		else
		  title_t :new
			render :action => :new
		end
	end
	
	def edit
    title_t :edit
	end
	
	def update
	  @topic.title = params[:topic][:title]
		@topic.content = params[:topic][:content]
		
		if @topic.save
		  flash_t :success
		  redirect_to project_topic_path(@project, @topic)
		else
		  title_t :edit
		  render :action => :edit
		end
	end
	
	def destroy
		if @topic.destroy
			flash_t :success
		else
		  flash_t_general :error, 'error.unknown'
		end
		redirect_to project_topics_path
	end
	
	private
	
	def get_topic
	  unless Topic.exists? params[:id]
	    flash_t_general :error, 'topic.dont_exists'
	    redirect_to project_topics_path
	    return
	  end
	  
	  @topic = Topic.find(params[:id])
	  
	  unless @project.topic_ids.include?(@topic.id)
	    flash_t_general :error, 'topic.not_included'
	    redirect_to project_topics_path
	  end
	end
	
  def can_edit	  
    unless can_edit?('forum') || current_user.topic_ids.include?(@topic.id)
      flash_t_general :error, 'error.privileges'
      redirect_to project_topics_path
    end
  end
end
