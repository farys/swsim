class User < ActiveRecord::Base
  has_many :sent_alerts, :class_name => 'Alert',:foreign_key => :author_id
  has_many :received_alerts, :class_name => 'Alert',:foreign_key => :reader_id
  has_many :auctions, :foreign_key => :owner_id
  has_many :won_in_auctions, :class_name => 'Auction', :as => :winner
  has_many :messages, :foreign_key => :owner_id, :order => 'id DESC'
  has_many :written_comments, :class_name => 'Comment', :foreign_key => :author_id
  has_many :received_comments, :class_name => 'Comment', :foreign_key => :receiver_id
  has_many :sent_offers, :class_name => 'Offer', :foreign_key => :offerer_id
  has_many :rated_values, :class_name => 'AuctionRating', :dependent => :delete_all
  has_many :memberships, :dependent => :destroy
  has_many :projects, :through => :memberships
  has_many :roles, :through => :memberships
  has_many :project_files, :dependent => :destroy
  
  def to_s
    self.login
  end
  
  def new_message params
    msg = self.messages.new params
    msg.author_id = self.id
    msg
  end
  
  def find_messages folder, page
    unless folder.eql?(:received) || folder.eql?(:sent)
      raise Exception.new('Niepoprawny typ wiadomosci')
    end
    
    self.messages.send(folder).paginate(:page => page, :per_page => 15)    
  end
end
