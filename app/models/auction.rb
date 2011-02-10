class Auction < ActiveRecord::Base
  STATUS_STAGES = 0
  STATUS_CANCELED = 1
  STATUS_FINISHED = 2
  PUBLIC_AUCTIONS_CONDITIONS = 'status = '+Auction::STATUS_STAGES.to_s+' AND stage = 1'
  
  #is_indexed :fields => [:title, :description, :expired],  
  #:concatenate => [{:association_name => :tags, :field => :id, :as => :tags_ids, :association_sql => 'LEFT OUTER JOIN auctions_tags ON (auctions_tags.auction_id=auctions.id) LEFT OUTER JOIN tags ON (tags.id=auctions_tags.tag_id)'}],
  #:conditions => Auction::PUBLIC_AUCTIONS,
  #:delta => {:field => 'expired'}
  
  belongs_to :category, :counter_cache => true
  belongs_to :owner, :class_name => 'User'
  belongs_to :won_offer, :class_name => 'Offer', :include => [:offerer]
  has_many :offers, :dependent => :destroy
  has_many :communications, :dependent => :delete_all, :order => 'id DESC'
  has_and_belongs_to_many :tags
  has_many :rating_values, :class_name => 'AuctionRating', :dependent => :delete_all
  
  define_index do
    indexes :title
    indexes :description
    indexes :budget_id
    indexes :expired
    indexes tags(:id), :as => :tags_ids
    
    where Auction::PUBLIC_AUCTIONS_CONDITIONS
  end

  validates_presence_of :title
  validates_presence_of :description
  validates_inclusion_of :status, :in => [0, 1, 2]
  validates_inclusion_of :budget_id, :in => Budget.ids
  validates_associated :category, :owner
  
  scope :has_tags, lambda {|tags| {:conditions => ['id in (SELECT auction_id FROM auctions_tags WHERE tag_id in (?))', tags.join(',')]}}
  
  #create form
  attr_accessor :expired_after
  validates_inclusion_of :expired_after, :in => (1..14).to_a.collect{|d| d.to_s}, :on => :create
  
  before_validation :init_auction_row, :on => :create
  def init_auction_row
    self.expired = DateTime.now + self.expired_after.to_i.days
    self.status = Auction::STATUS_STAGES
  end

  before_update :won_offer_choosed, :if => ->{ self.won_offer_id_changed? }
  def won_offer_choosed
    if self.won_offer_id_changed?
      self.status = Auction::STATUS_FINISHED 
      self.offers.latest.stay_on [self.won_offer_id]
    end
  end
  
  before_update :status_changed, :if => ->{ self.status_changed? }
  def status_changed
    self.category.decrement! :auctions_count
    self.expired = DateTime.now
  end

  def self.from_category(category, page = 1, per_page = 15, order = 'expired ASC')
    paginate(
      :page => page,
      :order => order,
      :per_page => per_page,
      :conditions => ['category_id in (?) AND '+Auction::PUBLIC_AUCTIONS_CONDITIONS, category.links.collect {|l| l.category_id}],
      :include => :offers
      )
  end

  #czy oferent moze zlozyc oferte
  def allowed_to_offer? user
    return false if self.owner.eql?(user)

    #todo dwa razy .count czy raz .all?
    offers = self.offers.latest.select {|offer| offer.offerer.eql?(user)}

    #niepotrzebne ale w wiekszosci przypadkow zakonczy sprawdzanie przed czasem
    return true if self.stage == 1 && offers.empty?
    return false if self.stage > 1 && offers.empty?

    offers.each do |offer|
      return false if offer.stage == self.stage || offer.status == Offer::STATUS_REJECTED
    end

    true
  end
  
  #oblicza srednia ocene aukcji, jesli aukcja nie zostala jeszcze oceniona to metoda zwroci nil
  def rating
  	return (self.ratings_sum.to_f / self.ratings_count).ceil.to_i if (self.ratings_count > 0)
  	return nil
  end

  #czy oferent jest uprawniony do ogladania aukcji
  def allowed_to_see? offerer
    self.offers.latest.each{|offer| return true if offer.offerer.eql?(offerer) && offer.rejected == 0}
    false
  end

  #czy oferent złożył już oferte na aktualnym etapie
  def made_offer? offerer
      not self.offers.latest.select {|offer| offer.offerer.eql?(offerer) && offer.stage == self.stage}.empty?
  end  

##
# Przenosi aukcje do nastepnego etapu , zmiany zostaja zapisane, zwraca true/false
# offers_ids id ofert ktore przechodza do kolejnego etapu
##
  def to_next_stage offers_ids
    self.offers.latest.stay_on(offers_ids)
    self.stage += 1
    self.save
  end
  
  def self.searchBySphinx(query = '', search_in_description = false, tags_ids = [], budgets_ids = [], page = 1, per_page = 15)

    unless search_in_description || query.length == 0
      query = '@title ' + query
    end
    
    unless tags_ids.empty?
      #options.merge! :weights => {:tag_list => 2}
      query += ' @tags_ids '+tags_ids.join(' | ')+''
    end
    
    unless budgets_ids.empty?
      #options.merge! :weights => {:tag_list => 2}
      query += ' @budget_id '+budgets_ids.join(' | ')+''
    end
    
    #options = {
     # :query => query,
    #  :class_names => :Auction,
    #  :page => page,
    #  :per_page => 15,
    #  :weights => {:tag_list => 3, :title => 2, :description => 1},
    #  :sort_mode => 'relevance',
    #}
    #Ultrasphinx::Search.new(options).run
    Rails.logger.info "ZAPYTANIE: "+query

    Auction.search query, 
      :field_weights => {:tags_ids => 3, :title => 2, :description => 1},
      :per_page => 15,
      :page => page,
      :sort_mode => :extended,
      :match_mode => :extended,
      :order => "@rank DESC"
  end
  
end
