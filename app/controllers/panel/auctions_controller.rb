class Panel::AuctionsController < Panel::ApplicationController  
  before_filter :load_auction, :except => [:index, :new, :create]
  before_filter :load_form_data, :only => [:new, :create]
  
  def index
    @status = params[:status].to_i || Auction::STATUS_ONLINE
    logger.warn @status
    @title = case @status
    when Auction::STATUS_ONLINE
      "aktualne"
    when Auction::STATUS_FINISHED
      "zakonczone"
    when Auction::STATUS_CANCELED
      "anulowane"
    end
    
    @auctions = @logged_user.auctions.with_status(@status).paginate :per_page => 15, :page => params[:page]
  end
  
  def new
    @auction = @logged_user.auctions.new :category_id => params[:category_id], :expired_after => 14    
  end

  def create
    @auction = @logged_user.auctions.new(params[:auction])
    
    if params.key? :tags
      @auction.tag_ids = params[:tags].keys
    end
    
    if @auction.save
      flash[:notice] = 'Aukcja zostala zapisana i opublikowana'
      redirect_to auction_path(@auction)
    else
      render :action => :new
    end
  end

  def won_offer
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
      flash[:warning] = 'Aukcja zostala anulowana'
    else
      flash[:error] = 'Anulowanie aukcji nie powiodlo sie!'
    end
    redirect_to panel_auctions_path
  end
  
  private
  def load_form_data
    @categories_to_list = Category.get_array
    @tags = Tag.order("name ASC").all
  end
  
  def load_auction
    options = nil
    options = {:include => [:owner, {:offers => :offerer}, :communications]} if params[:action].eql?('show')
    @auction = @logged_user.auctions.find(params[:id], options)
  end
end
