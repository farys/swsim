#TODO osobny modul do powiadomien ?
class Panel::AlertsController < Panel::ApplicationController
  before_filter :fetch_decision, :only => [:reject_offer]

  def index

  end

  def show
    
  end

  #rozpatrzenie zgloszenia o odrzucenie oferty - wlasciciel aukcji
  def reject_offer
    @auction = @logged_user.auctions.find(params[:auction_id])
    @offer = @auction.offers.find(params[:offer_id])
    Alert.transaction do
      Alert.offer_to_reject_response!(@offer, @decision)
      if @decision
        @offer.reject!
      end
    end
  end

  private
  def fetch_decision
    #niemozna decydowac za uzytkownika, dlatego nie jest ustawiana domyslna decyzja
    unless params.has_key?(:decision)
      flash[:error] = 'Brakuje decyzji'
      redirect_to :back
    end

    @decision = params[:decision].to_b
  end
end