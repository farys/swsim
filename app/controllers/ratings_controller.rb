class RatingsController < ApplicationController
  before_filter :login_required
  
  def create
    @auction = Auction.find(params[:auction_id])
  	if @auction.rated_by?(@current_user)
  		render :text => 'rated'
  		return
  	end
    
    @auction.rate(@current_user, params[:value])
    render :text => 'ok'
  end
end
