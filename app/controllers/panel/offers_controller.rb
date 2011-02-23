class Panel::OffersController < Panel::ApplicationController

  def index
    @status = (params[:status] || -1).to_i

    @offers = @logged_user.sent_offers.with_status(@status)
    @title = case @status
    when Offer::STATUS_NORMAL
      "biorace udzial w aukcji"
    when Offer::STATUS_REJECTED
      "odrzucone"
    when Offer::STATUS_WON
      "wygrane"
    when -1
      "wszystkie"
    end
  end
  
  #wyslij komunikat do wlasciciela aukcji z prosba o odrzucenie oferty
  def alert_reject
    
    redirect_to :back
  end
  
  #oferte moze wycofac tylko wlasciciel aukcji
  def destroy
    @auction = @logged_user.auctions.find(params[:auction_id])
    @offer = @auction.offers.find(params[:id])
    @offer.status = Offer::STATUS_REJECTED
    @offer.save
    redirect_to :back
  end
end