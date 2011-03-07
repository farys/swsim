class Admin::OffersController < Admin::ApplicationController
  before_filter :load_auction_and_offer

  def recovery
    if @offer.recovery!
      flash[:success] = flash_t
    end
    redirect_to :back
  end

  def destroy
    @offer.reject!
    redirect_to :back, :notice => flash_t
  end

  private
  def load_auction_and_offer
    @auction = Auction.find(params[:auction_id])
    @offer = @auction.offers.find(params[:id])
  end
end