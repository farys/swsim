# Methods added to this helper will be available to all templates in the application.
module AuctionsHelper
  def escape_auction(auction)
    auction.title
  end
end
