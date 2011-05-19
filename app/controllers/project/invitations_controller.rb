class Project::InvitationsController < Project::ApplicationController
  before_filter :get_invitation, :only => [:cancel, :destroy]
  before_filter :check_privileges, :except => [:index, :accept, :reject]
  before_filter :get_reciver_invitation, :only => [:accept, :reject]
  
  def index
    title_t :index
    @invitations = @project.invitations.paginate :per_page => 15,
		                                             :page => params[:page]
  end
  
  def new
    title_t :new
    @invitation = Invitation.new(:project_id => @project.id)
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.project_id = @project.id
    
  	#weryfikacja uzytkownika
  	unless User.exists? @invitation.user_id
  	  flash.now[:error] = t('flash.general.user.dont_exists')
  	  render_new
  	  return
  	end
  	
  	if @project.user_ids.include? @invitation.user_id
  		flash.now[:notice] = t('flash.project.members.member_exists')
  		render_new
  	  return 
  	end
  	
  	#weryfikacja roli
  	unless Role.exists? @invitation.role_id
  	  flash.now[:error] = t('flash.general.role.dont_exists')
  	  render_new
  	  return
  	end
  	
  	if @invitation.role_id == Role.get_id('owner') ||
    	 @invitation.role_id == Role.get_id('leader')
    	flash.now[:notice] = t('flash.general.role.invalid_role')
    	render_new
  	  return
    end
    
    inv_users = []
    @project.invitations.each do |i|
      inv_users << i.user_id if i.status == Invitation::STATUSES[:pending]
    end
    
    if inv_users.include? @invitation.user_id
      flash.now[:notice] = t('flash.project.invitations.exists')
      render_new
      return
    end
          
    if @invitation.save
      role = Role.find(@invitation.role_id)
      auction = Auction.find(@project.auction_id)
      
      @role = t("role.name.#{role.send("name")}")
      @auction_link = "<a href=\"/auctions/#{auction.id}\" target=\"_blank\">#{auction.title}</a>"
      @accept_link = "<a href=\"/projects/#{@project.id}/invitations/#{@invitation.id}/accept\">#{t('general.project.invitation.accept')}</a>"
      @reject_link = "<a href=\"/projects/#{@project.id}/invitations/#{@invitation.id}/reject\">#{t('general.project.invitation.reject')}</a>"
      
      body = t('general.project.invitation.body')    
      body.scan(/{[^}]+}/).each do |var|
        body[var] = eval("->"+var+".call").to_s
      end
      @body = body
      
      msg = Message.new(:receiver_id => @invitation.user_id,
                        :owner_id => @invitation.user_id,
                        :author_id => current_user.id,
                        :topic => t('general.project.invitation.topic'),
                        :body => @body)
      
      if msg.save
        flash_t :success
      else
        @invitation.destroy
        flash_t_general :error, 'error.unknown'
      end
      
      redirect_to project_invitations_path    
    else
      render_new
    end
  end
  
  def destroy
    if @invitation.status == Invitation::STATUSES[:pending]
      flash_t :error, 'destroy_error'
      redirect_to project_invitations_path
      return  
    end
    
    if @invitation.destroy
      flash_t :success
    else
      flash_t_general :error, 'error.unknown'
    end
    redirect_to project_invitations_path
  end
  
  def accept 
    @invitation.status = Invitation::STATUSES[:accepted]
    if @invitation.save
      Membership.create(:project_id => @invitation.project_id,
                        :user_id => @invitation.user_id,
                        :role_id => @invitation.role_id)
      flash_t :success
      redirect_to project_info_path(@invitation.project_id)
    else
      flash_t_general 'error.unknown'
      redirect_to panel_messages_path
    end  
  end
  
  def reject   
    @invitation.status = Invitation::STATUSES[:rejected]
    if @invitation.save
      flash_t :success
    else
      flash_t_general 'error.unknown'
    end
    redirect_to panel_messages_path  
  end
  
  def cancel
    unless @invitation.status == Invitation::STATUSES[:pending]
      flash_t :error, 'cancel_error'
      redirect_to project_invitations_path
      return
    end
    
    @invitation.status = Invitation::STATUSES[:canceled]
    
    if @invitation.save
      flash_t :success
    else
      flash_t_general :error, 'error.unknown'
    end
    redirect_to project_invitations_path
  end
  
  private
  
  def get_invitation
    unless Invitation.exists? params[:id]
      flash_t_general :error, 'invitation.dont_exists'
      redirect_to project_invitations_path(@project)
      return
    end
    @invitation = Invitation.find(params[:id])
  end
  
  def get_reciver_invitation
    unless Invitation.exists? params[:id]
      flash_t_general :error, 'invitation.dont_exists'
      redirect_to panel_messages_path
      return
    end
    @invitation = Invitation.find(params[:id])
    
    unless @invitation.user_id == current_user.id
      flash_t_general :error, 'error.privileges'
      redirect_to panel_messages_path
      return
    end
    
    if @invitation.status == Invitation::STATUSES[:canceled]
      flash_t :notice, 'canceled'
      redirect_to panel_messages_path
      return
    end
    
    if @invitation.status == Invitation::STATUSES[:accepted]
      redirect_to project_info_path(@invitation.project_id)
      return
    end
    
    if @invitation.status == Invitation::STATUSES[:rejected]
      redirect_to panel_messages_path
      return
    end
    
  end
  
  def check_privileges
    unless can_edit?('invitation')
  	  flash_t_general :errors, 'error.privileges'
  		redirect_to project_invitations_path
  	end
  end
  
  def render_new
    title_t :new
  	render :action => :new
  end
end
