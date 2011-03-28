class Project::MembersController < Project::ApplicationController 
  before_filter :check_privileges, :except => :index
   
  def index
    title_t :index
  end
  
  def new
  	title_t :new	
  end
  
  def update
  	memb = Membership.where(:user_id => params[:membership][:user_id], :project_id => params[:project_id]).first
  	memb.role_id = params[:membership][:role_id].to_i
  	memb.save!
  	title_t :index
  	redirect_to project_members_path
  end
  
  private
  def check_privileges
  	unless can_edit?('user')
  		title_t :index
  		render :index
  	end
  end
end