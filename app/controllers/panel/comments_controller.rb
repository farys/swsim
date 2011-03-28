class Panel::CommentsController < Panel::ApplicationController
  before_filter :comment_and_form_data, :only => [:edit, :update]
    
  def index	
    @status = params[:status] || :received
    title_t @status
    @comments = current_user.send(@status.to_s+"_comments").active.paginate :per_page => 15, :page => params[:page]
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
    if @comment.save
      @comment.activate!
      if @comment.owner_comment?
        Comment.create_from_owner_comment(@comment)
      end
      Sender.user_commented(@comment).deliver
      redirect_to queue_panel_comments_path, :notice => flash_t
    else
      title_t :edit
      render :edit
    end
  end

  def show
    title_t
    @comment = Comment.active.find(params[:id])
  end

  private
  def comment_and_form_data
    @comment = current_user.written_comments.pending.find(params[:id])

    if @comment.points_mode?
      @leader_comment = Comment.
        where(:project_id => @comment.project.id).
        where(:receiver_id => @comment.project.leader_id).
        first
      @allowed_points = @leader_comment.values.sum(:rating);
      @comment.allowed_points = @allowed_points
    end

    @keywords = CommentKeyword.all
    @receiver = @comment.receiver
    @values = (params[:comment_value].nil?)?
      CommentKeyword.create_comment_values : @comment.values.build(params[:comment_value].values)
  end
end
