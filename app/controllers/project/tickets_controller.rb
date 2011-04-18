class Project::TicketsController < Project::ApplicationController
  def index
    title_t :index
    @tickets = @project.tickets.paginate :per_page => 15,
    																	   :page => params[:page]
  end
end
