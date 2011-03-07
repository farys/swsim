class Panel::ProjectsController < Panel::ApplicationController
  
  def index
    @projects = Project.find(@logged_user.membership_ids).paginate :per_page => 15, :page => params[:page]
  end
end