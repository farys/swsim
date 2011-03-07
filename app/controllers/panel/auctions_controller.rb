class Panel::AuctionsController < Panel::ApplicationController  
  before_filter :load_auction, :except => [:index, :new, :create]
  before_filter :new_auction_and_form_data, :only => [:new, :create]
  
  def index
    @status = params[:status] || :active
    title_t @status
    @auctions = @logged_user.auctions.with_status(@status).paginate :per_page => 15, :page => params[:page]
  end
  
  def new
    unless params[:from_id].nil?
      @old_auction = @logged_user.auctions.find(params[:from_id])
      @auction = @old_auction.clone
      @auction.tag_ids = @old_auction.tag_ids
    end
    @auction.expired_after = 14
    title_t
  end

  def create    
    if @auction.save
      redirect_to auction_path(@auction), :notice => flash_t
    else
      title_t :new
      render :action => :new
    end
  end

  def offers
    title_t
    @offers = @auction.offers
  end

  def update
    if @auction.set_won_offer!(params[:auction][:won_offer_id])
      redirect_to auction_path(@auction), :notice => flash_t
    else
      title_t :offers
      render :offers
    end
  end

  def destroy
    @auction.cancel!
    redirect_to panel_auctions_path, :notice => flash_t
  end
  
  private
  def new_auction_and_form_data
    @auction = @logged_user.auctions.new(params[:auction])
    @auction.tag_ids = params[:tag_ids].values unless params[:tag_ids].nil?
    @groups = Group.all
  end

  def load_auction
    options = nil
    options = {:include => [:owner, {:offers => :offerer}, :communications]} if params[:action].eql?('show')
    @auction = @logged_user.auctions.find(params[:id], options)
  end
end
