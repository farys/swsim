class BlogpostsController < ApplicationController
  before_filter :authorized_user, :only => :destroy
  
  def index
  	@user = User.find(params[:user_id])
  	@title = "#{@user.name} #{@user.lastname} || Blog"
  	if @user.blogposts.empty?
  		flash.now[:error] = "Brak wpisow"
  	else
  	@blogposts = @user.blogposts.paginate(:page => params[:page])
  	end
  end
  
  def new
  	@user = User.find(params[:user_id])
  	@title = "#{@user.name} #{@user.lastname} || Blog || Nowy wpis"
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
  	@title = "#{@user.name} #{@user.lastname} || Blog"
  	@blogpost = Blogpost.find(params[:id])
  	@comments = Blogcomment.find_all_by_blogpost_id(@blogpost).paginate(:page => params[:page], :per_page => 10)
  end
  
  def edit
  	@user = User.find_by_id(params[:user_id])
  	@blogpost = Blogpost.find(params[:id])
  	@title = "#{@user.name} #{@user.lastname} || Edycja wpisu: #{@blogpost.title}"
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
  
  def admin
  	@blogpost = Blogpost.find(params[:id])
  	if @blogpost.update_attribute(:admin, 1)
  		@user = User.find(params[:user_id])
  		@title = "#{@user.name} #{@user.lastname} || Blog"
  		@comments = Blogcomment.find_all_by_blogpost_id(@blogpost)
  		flash[:success] = "Zgloszono wpis do administratora"
  		render :action => :show
  	end
  end

  private

    def authorized_user
      @blogpost = Blogpost.find(params[:id])
      redirect_to root_path unless current_user?(@blogpost.user)
    end
end
