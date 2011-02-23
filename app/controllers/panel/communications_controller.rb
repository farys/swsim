class Panel::CommunicationsController < Panel::ApplicationController 
  before_filter :load_auction_and_form_data
  
  def new
  end

  def create
    if @communication.save
      flash[:notice] = 'Komunikat zostal opublikowany'
      redirect_to auction_path(@auction)
    else
      render :new
    end
  end
  
  private
  
  def load_auction_and_form_data
    params[:communication] ||= Hash.new
    @auction = @logged_user.auctions.online.find(params[:auction_id])
    @communication = @auction.communications.new(params[:communication])
  end
end
