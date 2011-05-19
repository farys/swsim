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
    if validate_recap(params, @blogpost.errors) && @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to user_blogposts_path(current_user)
    else
      @user = current_user
      render :new
    end
  end
  
  def show
  	@blogpost = Blogpost.find(params[:id])
  	@user = User.find_by_id(@blogpost.user_id)
  	@title = "#{@user.name} #{@user.lastname} || Blog"
  	if signed_in?
  		@useful = Useful.find_by_user_id_and_blogpost_id(current_user.id, @blogpost.id)
  	end
  	@comments = Blogcomment.find_all_by_blogpost_id(@blogpost).paginate(:page => params[:page], :per_page => 10)
  end
  
  def edit
  	@user = User.find_by_id(params[:user_id])
  	@blogpost = Blogpost.find(params[:id])
  	if current_user.id != @blogpost.user_id
  		redirect_to user_blogpost_path(@user, @blogpost)
  	else
  	@title = "#{@user.name} #{@user.lastname} || Edycja wpisu"
  	end
  end
  
  def update
  	@blogpost = Blogpost.find(params[:id])
	if validate_recap(params, @blogpost.errors) && @blogpost.update_attributes(params[:blogpost])
		redirect_to user_blogpost_path(current_user)
		flash_t :notice
	else
		@user = current_user
		@title = "#{@user.name} #{@user.lastname} || Edycja wpisu"
		render :action => :edit
	end
  end

  def destroy
    @blogpost.destroy
    flash[:success] = "Blogpost usuniety!"
    redirect_to user_blogposts_path(current_user)
  end
  
  def admin
  	@blogpost = Blogpost.find(params[:id])
  	if @blogpost.update_attribute(:admin, 1)
  		@user = User.find(params[:user_id])
  		@title = "#{@user.name} #{@user.lastname} || Blog"
  		@comments = Blogcomment.find_all_by_blogpost_id(@blogpost).paginate(:page => params[:page], :per_page => 10)
  		flash[:success] = "Zgloszono wpis do administratora"
  		redirect_to user_blogpost_path(@user, @blogpost)
  	end
  end

  private

    def authorized_user
      @blogpost = Blogpost.find(params[:id])
      redirect_to root_path unless current_user?(@blogpost.user)
    end
end
