class OffersController < ApplicationController
  before_filter :login_required
  
  def create
    @offer = @logged_user.sent_offers.new params[:offer]
    
    if @offer.save
      flash[:notice] = "Oferta zostala zlozona!"
      redirect_to auction_path(@offer.auction_id)
    end
  end
end
