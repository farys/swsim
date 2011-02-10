class User < ActiveRecord::Base
  has_many :alerts, :foreign_key => :author_id
  has_many :auctions, :foreign_key => :owner_id
  has_many :won_in_auctions, :class_name => 'Auction', :as => :winner
  has_many :sent_messages, :class_name => 'Message', :foreign_key => :author_id
  has_many :received_messages, :class_name => 'Message', :foreign_key => :receiver_id
  has_many :written_comments, :class_name => 'Comment', :foreign_key => :author_id
  has_many :received_comments, :class_name => 'Comment', :foreign_key => :receiver_id
  has_many :sent_offers, :as => :offerer, :class_name => 'Offer'#, :foreign_key => :oferrer_id #? sent_offers.build?
  has_many :rated_values, :class_name => 'AuctionRating', :dependent => :delete_all
  
  def name
    self.login
  end
end
