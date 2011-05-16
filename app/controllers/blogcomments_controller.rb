class BlogcommentsController < ApplicationController
  
  def show
  	@user = User.find(params[:user_id])
  	@blogpost = Blogpost.find(params[:blogpost_id])
  	@comment = Blogcomment.find(params[:id])
  	@title = "Komentarz"
  end
  
  def new
  	@user = current_user
  	@blogpost = Blogpost.find(params[:blogpost_id])
  	@blogcomment = Blogcomment.new
  end
  
  def create
  	@blogpost = Blogpost.find(params[:blogpost_id])
    @blogcomment  = Blogcomment.create!(:content => params[:blogcomment][:content], :blogpost_id => params[:blogpost_id], :user_id => current_user.id)
    flash[:success] = "Comment created!"
    redirect_to user_blogpost_path(@blogpost.user_id, @blogpost)
  end
  
  def edit
  	@blogcomment = Blogcomment.find(params[:id])
  	@blogpost = Blogpost.find_by_id(@blogcomment.blogpost_id)
  	@title = "Edycja komentarza dla wpisu: #{@blogpost.title}"
  end
  
  def update
  	@blogcomment = Blogcomment.find(params[:id])
  	@blogpost = Blogpost.find_by_id(@blogcomment.blogpost_id)
	if @blogcomment.update_attributes(params[:blogcomment])
		redirect_to user_blogpost_path(@blogpost.user_id, @blogcomment.blogpost_id)
		flash[:success] = "Comment edited!"
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