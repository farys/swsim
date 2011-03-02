class Admin::AuctionsController < Admin::ApplicationController
  before_filter :form_data, :only => [:update, :edit]#TODO czy edycja potrzebna?
  before_filter :load_auction, :only => [:show, :edit, :update, :destroy]
  
  def index
    @status = Array.new
    @date = Time.new
  end

  def result
    @query = params[:query] || ""
    @on_date = params[:on_date] || false
    d = params[:date]
    @date = Date::civil(d[:year].to_i, d[:month].to_i, d[:day].to_i)
    @date_to_search = if @on_date.nil? then; nil; else @date; end
    @status = (params[:status] || {}).values.map(&:to_i)

    @auctions = Auction.admin_search(@query, @date_to_search, @status, params[:page])
  end

  def show
    @tags = @auction.tags
    @offers = @auction.offers
    @communications = @auction.communications
  end

  def edit
  end

  def update
    @auction.tag_ids = (params[:tag_ids] || {}).values
    if @auction.update_attributes params[:auction]
      flash[:notice] = 'Aukcja zostala zaktualizowana'
      redirect_to auction_path(@auction)
    else
      render :won_offer
    end
  end

  def destroy
    if @auction.cancel!
      flash[:notice] = 'Aukcja zostala anulowana'
      redirect_to admin_auctions_path
    end
  end

  private
  def form_data
    @groups = Group.all
  end

  def load_auction
    @auction = Auction.find params[:id]
  end
end
