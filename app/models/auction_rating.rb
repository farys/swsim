class AuctionRating < ActiveRecord::Base
	belongs_to :user
	belongs_to :auction
	
	validates :user, :presence => true, :associated => true;
	validates :auction, :presence => true, :associated => true;
	validates :value, :presence => true
end