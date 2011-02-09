class OffersController < ApplicationController

  def create
    #todo
    @offer = Offer.new params[:offer]
    @offer.offerer = @logged_user
    
    if @offer.save
      flash[:notice] = "Oferta została złożona!"
      redirect_to @offer.auction
    end
  end
end
