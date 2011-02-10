#encoding: UTF-8
class RatingsController < ApplicationController
  def create
  	if @logged_user.nil?
  		render :text => 'log_in'
  		return
  	end
  	if AuctionRating.where("user_id="+@logged_user.id.to_s+" AND auction_id="+params[:auction_id]).exists?
  		render :text => 'rated'
  		return
  	end
    unless @logged_user.nil?
    	@logged_user.rated_values.create :value => params[:value], :auction_id => params[:auction_id]
    	render :text => 'ok'
	end
  end
end
