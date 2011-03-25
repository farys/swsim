class Project::MembersController < Project::ApplicationController 
  before_filter :check_privileges, :except => :show
   
  def show
    title_t :show
  end
  
  def new
  	title_t :new	
  end
  
  def update
  	title_t :show
  	render :show
  end
  
  private
  def check_privileges
  	unless can_edit?('user')
  		title_t :show
  		render :show
  	end
  end
end