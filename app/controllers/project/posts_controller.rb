class Project::PostsController < Project::ApplicationController
  before_filter :get_topic
  before_filter :edit_post, :only => [:edit, :update, :destroy]
  
  def new
    @post = Post.new
    title_t :new
  end
  
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    @post.topic_id = @topic.id
    
    if @post.save
      flash_t :success
      redirect_to project_topic_path(@project, @topic)
    else
      title_t :new
      render :action => :new
    end
  end
  
  def edit
    title_t :edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    @post.content = params[:post][:content]
    
    if @post.save
      flash_t :success
      redirect_to project_topic_path(@project, @topic)
    else
      title_t :edit
      render :action => :edit
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    
    if post.destroy
      flash_t :success     
    else
      flash_t_general :error, 'general.error.unknown'
    end
    redirect_to project_topic_path(@project, @topic)
  end
  
  private
  
  #sprawdzenie uprawnien do edycji postow
  def edit_post
    unless Post.exists? params[:id]
      flash_t_general :error, 'post.dont_exists'
      redirect_to project_topic_path(@project, @topic)
    end
  
  	if can_edit?('forum')
  		true
  	elsif current_user.post_ids.include?(params[:id]) && @project.active?
  		true
  	else
  		false
  	end
  end
  
  def get_topic
    unless Topic.exists? params[:topic_id]
      flash_t_general :error, 'topic.dont_exists'
      redirect_to project_topics_path
    end
    
    @topic = Topic.find(params[:topic_id])
  end
  
  def check_read_privileges
	  unless Post.exists? params[:id]
	    flash_t_general :error, 'post.dont_exists'
	    redirect_to project_topic_path(@project, @topics)
	    return
	  end
	  
	  unless @topic.post_ids.include?(params[:id].to_i)
	    flash_t_general :error, 'post.not_included'
	    redirect_to project_topic_path(@project, @topics)
	  end
	end
end
