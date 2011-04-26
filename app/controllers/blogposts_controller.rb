class BlogpostsController < ApplicationController
  before_filter :authorized_user, :only => :destroy
  
  def index
  	@title = "Blog"
  	@user = User.find(params[:user_id])
  	if @user.blogposts.empty?
  		flash[:error] = "Brak wpisow"
  	else
  	@blogposts = @user.blogposts.paginate(:page => params[:page])
  	end
  end
  
  def new
  	@user = User.find(params[:user_id])
	@blogpost = Blogpost.new
  end

  def create
    @blogpost  = current_user.blogposts.build(params[:blogpost])
    if @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to user_blogposts_path(current_user)
    else
      flash[:error] = "Zle parametry"
      redirect_to new_user_blogpost_path(current_user)
    end
  end
  
  def show
  	@user = User.find(params[:user_id])
  	@blogpost = Blogpost.find(params[:id])
  	@comments = @blogpost.comments.paginate(:page => params[:page])
  	@title = "Blog"
  end
  
  def edit
  	@title = "Edit post"
  	@blogpost = Blogpost.find(params[:id])
  end
  
  def update
  	@blogpost = Blogpost.find(params[:id])
	if @blogpost.update_attributes(params[:blogpost])
		redirect_to user_blogpost_path(current_user)
		flash_t :notice
	else
		@title = "Edit post"
		render :action => :edit
	end
  end

  def destroy
    @blogpost.destroy
    redirect_to user_blogposts_path(current_user)
  end

  private

    def authorized_user
      @blogpost = Blogpost.find(params[:id])
      redirect_to root_path unless current_user?(@blogpost.user)
    end
end