class Admin::TagsController < Admin::ApplicationController
  before_filter :load_tag, :only => [:edit, :update, :destroy]
  before_filter :new_tag, :only => [:new, :create]

  def index
    @status = params[:status] || "all"
    @tags = Tag
    @tags = @tags.unlinked if @status.eql?("unlinked")
    @tags = @tags.paginate :page => params[:page], :per_page => 15
    title_t @status
  end

  def new
    title_t
  end

  def create
    if @tag.save
      flash_t :success
      redirect_to admin_tags_path
    else
      title_t :new
      render :new
    end
  end

  def edit
    title_t
    render :new
  end

  def update
    if @tag.update_attributes params[:tag]
      flash_t :success
      redirect_to admin_tags_path
    else
      title_t :edit
      render :new
    end
  end

  def destroy
    @tag.destroy
    redirect_to :back, :notice => flash_t
  end

  private

  def load_tag
    @tag = Tag.find(params[:id])
  end

  def new_tag
    @tag = Tag.new params[:tag]
  end
end