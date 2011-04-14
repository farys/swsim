class Project::MembersController < Project::ApplicationController 
  before_filter :check_privileges, :except => :index
   
  def index
    title_t :index
  end
  
  def update
  	@memb = Membership.where(:user_id => params[:membership][:user_id],
  													:project_id => @project.id).first
    role = params[:membership][:role_id]
  	  	
  	#weryfikacja czlonkostwa
  	if @memb.nil?
  	  flash.now[:error] = t('general.membership.dont_exists')
  	  render_index
  	  return
  	end
  	
  	#weryfikacja uzytkownika
  	if @memb.role_id == Role.get_id('owner') ||
  		 @memb.role_id == Role.get_id('leader')
  	  flash_t :notice, 'cant_change_role'
  	  render_index
  	  return
  	end
  	
  	#weryfikacja roli	 
    if role == Role.get_id('owner') ||
       role == Role.get_id('leader')
      flash_t_general :notice, 'role.invalid_role'
      render_index
      return
    end      
    
    #uaktualnienie roli uzytkownika
  	@memb.role_id = role
  	if @memb.save
  	  flash_t :success
  	  redirect_to project_members_path
		else
		  render_index
  	end
  end
  
  def destroy
		memb = Membership.find(params[:id])
		
		#weryfikacja czlonkostwa
  	if memb.nil?
  	  flash.now[:error] = t('general.membership.dont_exists')
  	  render_index
  	  return
  	end
  	
  	#weryfikacja roli	 
    if memb.role == Role.get_id('owner') ||
       memb.role == Role.get_id('leader')
      flash_t :notice, 'cant_delete'
      render_index
      return
    end 													
	  
	  #usuwanie uzytkownika
    if memb.destroy
    	flash_t :success
    	redirect_to project_members_path
  	else
  	  flash_t_general :error, 'error.unknown'
  	  redirect_to project_members_path
    end
  end
  
  private
  
  #sprawdzenie uprawnien do edycji
  def check_privileges
  	unless can_edit?('member')
  	  flash_t_general :errors, 'error.privileges'
  		redirect_to project_members_path
  	end
  end
  
  def render_new
    title_t :new
  	render :action => :new
  end
  
  def render_index
    title_t :index
    render :action => :index
  end
end
