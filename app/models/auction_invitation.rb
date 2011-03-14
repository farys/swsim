class AuctionInvitation < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user
end
