# Methods added to this helper will be available to all templates in the application.
module AuctionsHelper
  def escape_auction(auction)
    auction.title
  end

  def link_auction(auction)
    link_to escape_auction(auction), auction_path(auction)
  end
end
