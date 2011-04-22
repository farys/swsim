class Project::TicketsController < Project::ApplicationController
  before_filter :check_privileges, :except => [:index, :show, :take, :give]
  before_filter :get_ticket, :except => [:index, :new, :create]
  before_filter :check_status, :only => [:update, :destroy, :take]
  def index
    title_t :index
    @tickets = @project.tickets.paginate :per_page => 15,
    																	   :page => params[:page]
  end
  
  def new
    title_t :new
    @ticket = Ticket.new
  end
  
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.project_id = @project.id
    @ticket.status = Ticket::STATUSES[:free]
    
    if @ticket.save
      flash_t :success
      redirect_to project_tickets_path
    else
      title_t :new
      render :new
    end
  end
  
  def show
    title_t :show
  end
  
  def edit
    title_t :edit
  end
  
  def update   
    @ticket.title = params[:ticket][:title]
    @ticket.description = params[:ticket][:description]
    @ticket.duration = params[:ticket][:duration]
    
    if @ticket.save
      flash_t :success
      redirect_to edit_project_ticket_path(@project, @ticket)
    else
      title_t :edit
      render :edit
    end   
  end
  
  def destroy 
    if @ticket.destroy
      flash_t :success
    else
      flash_t_general :error, 'error.unknown'
    end
    redirect_to project_tickets_path
  end
  
  def take
    @ticket.user_id = current_user.id
    @ticket.status = Ticket::STATUSES[:implementation]
    
    if @ticket.save
      flash_t :success
    else
      flash_t_general :error, 'error.unknown'
    end
    redirect_to project_tickets_path
  end
  
  def give
    unless @ticket.status == Ticket::STATUSES[:implementation]
      flash_t_general :error, 'error.privileges'
      redirect_to project_tickets_path
      return
    end
    
    @ticket.user_id = nil
    @ticket.status = Ticket::STATUSES[:free]
    
    if @ticket.save
      flash_t :success
    else
      flash_t_general :error, 'error.unknown'
    end
    redirect_to project_tickets_path
  end
  
  private
  
  def check_privileges
    unless can_edit?('ticket')
  	  flash_t_general :error, 'error.privileges'
  		redirect_to project_tickets_path
  	end
  end
  
  def get_ticket
    unless Ticket.exists? params[:id]
      flash_t_general :error, 'ticket.dont_exists'
      redirect_to project_tickets_path
      return
    end
    @ticket = Ticket.find params[:id]
    
    unless @project.ticket_ids.include? @ticket.id
      flash_t_general :error, 'ticket.not_included'
      redirect_to project_tickets_path
    end
  end
  
  def check_status
    unless @ticket.status == Ticket::STATUSES[:free]
      flash_t_general :error, 'error.privileges'
      redirect_to project_tickets_path    
    end
  end
end
