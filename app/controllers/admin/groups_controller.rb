class Admin::GroupsController < Admin::ApplicationController
  before_filter :load_group, :only => [:update, :edit, :destroy]
  before_filter :new_group, :only => [:new, :create]
  before_filter :load_form_data, :only => [:new, :create, :edit, :update]
  before_filter :parse_tag_ids_from_post, :only => [:create, :update]

  def index
    @groups = Group.all
    title_t
  end

  def new
    title_t
  end

  def create
    if @group.save
      redirect_to admin_groups_path, :success => flash_t
    else
      title_t :new
      render :new
    end
  end

  def update
    if @group.update_attributes(params[:group])
      flash_t :success
      redirect_to admin_groups_path
    else
      title_t :edit
      render :new
    end
  end

  def edit
    title_t
    render :new
  end

  def destroy
    @group.destroy
    flash_t :notice
    redirect_to :back
  end

  private
  def load_group
    @group = Group.find(params[:id])
  end

  def new_group
    @group = Group.new params[:group]
  end

  def load_form_data
    @tags = @group.tags
  end

  def parse_tag_ids_from_post
    @group.tag_ids = (params[:tag_ids] || {}).values
  end
end