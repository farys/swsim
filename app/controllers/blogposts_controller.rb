class BlogpostsController < ApplicationController
  before_filter :authorized_user, :only => :destroy

  def create
    @blogpost  = current_user.blogposts.build(params[:blogpost])
    if @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to root_path
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
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end
end
