class Panel::AuctionsController < Panel::ApplicationController  
  before_filter :load_auction, :except => [:index, :new, :create]
  before_filter :new_auction_and_form_data, :only => [:new, :create]
  
  def index
    @status = params[:status].to_i || Auction::STATUS_ONLINE
    
    @auctions = @logged_user.auctions.with_status(@status).paginate :per_page => 15, :page => params[:page]
  end
  
  def new
    @auction.expired_after = 14
  end

  def create    
    if @auction.save
      flash[:notice] = 'Aukcja zostala zapisana i opublikowana'
      redirect_to auction_path(@auction)
    else
      render :action => :new
    end
  end

  def offers
    @offers = @auction.offers
  end

  def update
    attr = {:won_offer_id => params[:auction][:won_offer_id]}

    if @auction.update_attributes(attr)
      flash[:notice] = 'Zwycieska oferta zostala wyznaczona'
      redirect_to auction_path(@auction)
    else
      render :won_offer
    end
  end

  def destroy
    @auction.status = Auction::STATUS_CANCELED
    if @auction.save
      flash[:notice] = 'Aukcja zostala anulowana'
    else
      flash[:error] = 'Anulowanie aukcji nie powiodlo sie!'
    end
    redirect_to panel_auctions_path
  end
  
  private
  def new_auction_and_form_data
    @auction = @logged_user.auctions.new(params[:auction])
    @auction.tag_ids = params[:tag_ids].values unless params[:tag_ids].nil?
    @groups = Group.includes(:tags).all
  end

  def load_auction
    options = nil
    options = {:include => [:owner, {:offers => :offerer}, :communications]} if params[:action].eql?('show')
    @auction = @logged_user.auctions.find(params[:id], options)
  end
end
