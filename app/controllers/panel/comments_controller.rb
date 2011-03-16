class Panel::CommentsController < Panel::ApplicationController
  before_filter :comment_and_form_data, :only => [:edit, :update]
    
  def index	
    @status = params[:status] || :received
    title_t @status
    @comments = current_user.send(@status.to_s+"_comments").paginate :per_page => 15, :page => params[:page]
  end
  
  def queue
    title_t
    @comments = current_user.written_comments.pending.all.paginate :per_page => 15, :page => params[:page]
    render :index
  end

  def edit
    title_t
  end

  def update
    if @comment.update_attributes(params[:comment])
      redirect_to panel_path, :notice => flash_t
    else
      title_t :edit
      render :edit
    end
  end
  
  private
  def comment_and_form_data
    @comment = current_user.written_comments.pending.find(params[:id])
    @keywords = CommentKeyword.all
    @receiver = @comment.receiver
  end
end
