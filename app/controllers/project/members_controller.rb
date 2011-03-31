class Project::MembersController < Project::ApplicationController 
  before_filter :check_privileges, :except => :index
   
  def index
    title_t :index
  end
  
  def new
  	title_t :new
  	@memb = Membership.new	
  end
  
  def create
  	@memb = Membership.new(:project_id => @project.id,
  												 :user_id => params[:membership][:user_id],
  												 :role_id => params[:membership][:role_id])
  	unless @project.user_ids.include? @memb.user_id
  		unless @memb.role_id == Role.get_id('owner') ||
    			   @memb.role_id == Role.get_id('leader')
    		if @memb.save
    			flash_t :success
    		end
    	end
  	end
  	redirect_to project_members_path
  end
  
  def update
  	memb = Membership.where(:user_id => params[:membership][:user_id],
  													:project_id => @project.id).first
  	unless memb.role_id == Role.get_id('owner') ||
  		     memb.role_id == Role.get_id('leader')
  		memb.role_id = params[:membership][:role_id]
  		if memb.save!
  			flash_t :success
  		end
  	end
  	redirect_to project_members_path
  end
  
  def destroy
		memb = Membership.find(params[:id])													
    unless memb.role_id == Role.get_id('owner') ||
    			 memb.role_id == Role.get_id('leader')
    	if memb.destroy
    		flash_t :success
    	end
    end
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