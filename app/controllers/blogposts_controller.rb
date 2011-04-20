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
		@blogpost = Blogpost.new
  end

  def create
    @blogpost  = current_user.blogposts.build(params[:blogpost])
    if @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to user_blogposts_path(current_user)
    else
      render 'users/show'
    end
  end

  def destroy
    @blogpost.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @blogpost = Blogpost.find(params[:id])
      redirect_to root_path unless current_user?(@blogpost.user)
    end
end