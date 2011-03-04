class Admin::AuctionsController < Admin::ApplicationController
  before_filter :load_auction, :only => [:show, :edit, :update, :destroy]
  before_filter :form_data, :only => [:edit, :update]#TODO czy edycja potrzebna?
  
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
  end
  
  def edit
    @communications = @auction.communications
  end

  def update
    @auction.tag_ids = (params[:tag_ids] || {}).values

    if @auction.update_attributes(params[:auction]) && @auction.update_offers(params[:offers])
      flash[:notice] = t("flash.admin.auctions.update")
      redirect_to admin_auctions_path
    else
      render :edit
    end
  end

  def destroy
    if @auction.cancel!
      flash[:notice] = t("flash.admin.auctions.destroy")
      redirect_to admin_auctions_path
    end
  end

  private
  def form_data
    @groups = Group.all
    @offers = @auction.offers
  end

  def load_auction
    @auction = Auction.find params[:id]
  end
end
