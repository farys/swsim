class BlogcommentsController < ApplicationController
  
  def show
  	@user = User.find(params[:user_id])
  	@blogpost = Blogpost.find(params[:blogpost_id])
  	@comment = Blogcomment.find(params[:id])
  	@title = "Komentarz"
  end
  
  def new
    title_t
  	@user = current_user
  	@blogpost = Blogpost.find(params[:blogpost_id])
  	@blogcomment = Blogcomment.new
  end
  
  def create
  	@blogpost = Blogpost.find(params[:blogpost_id])
    @blogcomment  = Blogcomment.new(:content => params[:blogcomment][:content], :blogpost_id => params[:blogpost_id], :user_id => current_user.id)
    if validate_recap(params, @blogcomment.errors) && @blogcomment.save
      flash_t :success
      redirect_to user_blogpost_path(@blogpost.user_id, @blogpost)
    else
      @user = current_user
      title_t :new
      render :new, :blogpost_id => params[:blogpost_id], :user_id => current_user.id
    end
  end
  
  def edit
  	@blogcomment = Blogcomment.find(params[:id])
  	@blogpost = Blogpost.find_by_id(@blogcomment.blogpost_id)
  	if current_user.id != @blogcomment.user_id
  		redirect_to user_blogpost_path(@blogpost.user_id, @blogcomment.blogpost_id)
  	else
  	@title = "Edycja komentarza dla wpisu: #{@blogpost.title}"
  	end
  end
  
  def update
  	@blogcomment = Blogcomment.find(params[:id])
  	@blogpost = Blogpost.find_by_id(@blogcomment.blogpost_id)
	if validate_recap(params, @blogcomment.errors) && @blogcomment.update_attributes(params[:blogcomment])
		redirect_to user_blogpost_path(@blogpost.user_id, @blogcomment.blogpost_id)
		flash_t :success
	else
		@title = "Edit comment"
		render :action => :edit
	end
  end
  
  def admin
  @blogcomment = Blogcomment.find(params[:id])
  	if @blogcomment.update_attribute(:admin, 1)
  		@user = User.find(@blogcomment.user_id)
  		@blogpost = Blogpost.find(@blogcomment.blogpost_id)
  		flash[:success] = "Zgloszono wpis do administratora"
  		redirect_to user_blogpost_path(@user, @blogpost)
  	end
  end
  
end
