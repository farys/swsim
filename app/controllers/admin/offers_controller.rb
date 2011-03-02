class Admin::OffersController < Admin::ApplicationController
  before_filter :load_auction_and_offer

  #wyslij komunikat do wlasciciela aukcji z prosba o odrzucenie oferty
  def recovery
    if @offer.recovery!
      flash[:success] = "Oferta zostala przywrocona"
    end
    redirect_to :back
  end

  #oferte moze wycofac tylko wlasciciel aukcji
  def destroy
    if @offer.reject!
      flash[:notice] = "Oferta zostala anulowana"
    end
    redirect_to :back
  end

  private
  def load_auction_and_offer
    @auction = Auction.find(params[:auction_id])
    @offer = @auction.offers.find(params[:id])
  end
end