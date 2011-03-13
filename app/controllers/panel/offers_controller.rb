class Panel::OffersController < Panel::ApplicationController

  def index
    @status = params[:status] || :active
    title_t @status
    @offers = current_user.sent_offers.with_status(@status.to_sym)
  end

  def create
    @auction = Auction.find(params[:auction_id])

    unless @auction.allowed_to_see?(current_user)
      redirect_to panel_path
    end
    data = params[:offer]
    data.merge!({:auction_id => params[:auction_id]})

    @offer = current_user.sent_offers.new data

    if @offer.save
      flash_t :notice
      redirect_to auction_path(@offer.auction_id)
    end
  end

  #oferte moze wycofac tylko wlasciciel aukcji #TODO czy potrzebne
  def destroy
    @auction = current_user.auctions.find(params[:auction_id])
    @offer = @auction.offers.find(params[:id])
    @offer.reject!
    redirect_to :back
  end
end