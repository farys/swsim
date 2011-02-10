class UsersController < ApplicationController
  def panel
    #todo ACL, /users/panel/ /users/1/panel
    @user = @logged_user
    @auctions_status = params[:auctions_status] || Auction::STATUS_STAGES
    @auctions = @user.auctions.where("status=?", @auctions_status)
  end

  def show

  end

end
