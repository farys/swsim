class Admin::AuctionsController < Admin::ApplicationController
  before_filter :load_auction, :only => [:show, :edit, :update, :destroy]
  before_filter :form_data, :only => [:edit, :update]
  
  def index
    @date = Time.new
    @query = params[:query] || ""
    @on_date = params[:on_date] || nil
    @order = (params[:order] || 0).to_i
    #date select
    d = params[:date]
    @date = (d.nil?)? Time.new : Date::civil(d[:year].to_i, d[:month].to_i, d[:day].to_i)
    @date_to_search = (@on_date.nil?)? nil : @date

    @status = (params[:status] || {}).values.map(&:to_i)
    @auctions = Auction.admin_search(@query, @date_to_search, @status, @order, params[:page])
    title_t
  end

  def edit
    title_t
  end

  def update
    @auction.tag_ids = (params[:tag_ids] || {}).values

    if @auction.update_attributes(params[:auction]) && @auction.update_offers(params[:offers])
      redirect_to admin_auctions_path, :notice => flash_t
    else
      title_t :edit
      render :edit
    end
  end

  def destroy
    if @auction.cancel!
      redirect_to admin_auctions_path, :notice => flash_t
    end
  end

  private
  def form_data
    @groups = Group.all
    @offers = @auction.offers
    @communications = @auction.communications
  end

  def load_auction
    @auction = Auction.find params[:id]
  end
end
