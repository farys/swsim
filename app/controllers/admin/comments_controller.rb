class Admin::CommentsController < Admin::ApplicationController
  before_filter :load_comment, :only => [:edit, :update, :destroy]
  before_filter :form_data, :only => [:edit, :update]
  
  def index
    @comments = Comment.
      where("author_id=:id OR receiver_id=:id", {:id => params[:user_id]}).
      paginate :page => params[:page], :per_page => 15
  end

  def edit
    session[:referer] = request.referer
    title_t
  end

  def update
    @values.each
    if @comment.update_attributes(params[:comment])
      redirect_to session[:referer], :notice => flash_t
    else
      title_t :edit
      render :edit
    end
  end

  private
  def form_data
    @author = @comment.author
    @receiver = @comment.receiver
    @auction = @comment.auction
    @project = @comment.project
    @values = @comment.values
    @keywords = CommentKeyword.all
    
    if @values.empty?
      @values = (params[:comment_value].nil?)?
        CommentKeyword.create_comment_values : @comment.values.build(params[:comment_value].values)
    end
  end

  def load_comment
    @comment = Comment.where(:id => params[:id]).first
  end
end
