class Admin::GroupsController < Admin::ApplicationController
  before_filter :load_form_data, :except => [:destroy, :show]
  before_filter :load_tag, :only => [:edit, :update, :show, :destroy]
  before_filter :new_tag, :only => [:new, :create]

  def index
    @query = params[:query] || ""
    @group_id = params[:group_id]
    @tags = Tag.admin_search(@query, @group_id, params[:page])
  end

  def new
  end

  def create
    if @tag.save
      flash[:success] = "Tag zostal utworzony"
      redirect_to admin_tag_path(@tag)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update_attributes params[:tag]
      flash[:success] = "Tag zostal zaktualizowany"
      redirect_to admin_tags_path
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @tag.destroy
    flash[:notice] = "Tag zostal usuniety"
    redirect_to :back
  end

  private
  def load_form_data
    @groups = Group.all
  end

  def load_tag
    @tag = Tag.find(params[:id])
  end

  def new_tag
    @tag = Tag.new params[:tag]
  end
end