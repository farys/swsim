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
    @blogcomment  = @blogpost.blogcomments.build(params[:blogcomment])
    if @blogcomment.save
      flash[:success] = "Comment created!"
      redirect_to user_blogpost_path(current_user, @blogpost)
    else
      flash[:error] = "Zle parametry"
      redirect_to user_path(current_user)
    end
  end
  
  def edit
  	@blogcomment = Blogcomment.find(params[:id])
  	@blogpost = Blogpost.find_by_id(@blogcomment.blogpost_id)
  	@title = "Edycja komentarza dla wpisu: #{@blogpost.title}"
  end
  
  def update
  	@blogcomment = Blogcomment.find(params[:id])
	if @blogcomment.update_attributes(params[:blogcomment])
		redirect_to user_blogpost_path(current_user, @blogcomment.blogpost_id)
		flash_t :notice
	else
		@title = "Edit comment"
		render :action => :edit
	end
  end
  
end