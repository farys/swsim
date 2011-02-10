class AuctionRating < ActiveRecord::Base
	after_save :update_auction, :on => :create
	belongs_to :user
	belongs_to :auction
	
	validates :user, :presence => true, :associated => true;
	validates :auction, :presence => true, :associated => true;
	validates_presence_of :value
	
	def update_auction
		#stats = AuctionRating.where("auction_id=" + self.auction_id).select('SUM(value) as sum, COUNT(1) as count').find()
		a = Auction.find(self.auction_id)
		a.ratings_sum += self.value
		a.ratings_count += 1
		a.save
	end
end