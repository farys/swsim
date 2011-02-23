class Auction < ActiveRecord::Base
  STATUS_ONLINE = 0
  STATUS_CANCELED = 1
  STATUS_FINISHED = 2
  
  belongs_to :category, :counter_cache => true
  belongs_to :owner, :class_name => 'User'
  belongs_to :won_offer, :class_name => 'Offer', :include => [:offerer] #has_one_and_belongs_to?
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
    
    where 'status = '+Auction::STATUS_ONLINE.to_s+' AND private = 0'
  end

  validates :title, :presence => true
  validates :description, :presence => true
  validates_inclusion_of :status, :in => [Auction::STATUS_ONLINE, Auction::STATUS_CANCELED, Auction::STATUS_FINISHED]
  validates_inclusion_of :budget_id, :in => Budget.ids
  validates_associated :category, :owner
  
  scope :has_tags, lambda { |tags| {:conditions => ['id in (SELECT auction_id FROM auctions_tags WHERE tag_id in (?))', tags.join(',')]}}
  scope :with_status, lambda { |status| where(:status => status)}
  scope :online, lambda { where(:status => Auction::STATUS_ONLINE)}
  scope :public, lambda { where(:private => false)}
  scope :in_categories, lambda {|categories_ids| where(:category_id => categories_ids)}
  
  before_validation :init_auction_row, :on => :create
  before_update :won_offer_choosed, :if => ->{ self.won_offer_id_changed? }
  before_update :status_changed, :if => ->{ self.status_changed? }
  
  #create form
  attr_accessor :expired_after
  validates_inclusion_of :expired_after, :in => (1..14).to_a.collect{|d| d.to_s}, :on => :create
  
  def to_s
    self.title
  end
  
  def init_auction_row
    self.expired = DateTime.now + self.expired_after.to_i.days
    self.status = Auction::STATUS_ONLINE
  end

  def won_offer_choosed
    self.status = Auction::STATUS_FINISHED 
  end
  
  def status_changed
    self.category.decrement! :auctions_count
    self.expired = DateTime.now
  end

  def self.from_category(category, page = 1, per_page = 15, order = 'expired ASC')
    self.in_categories(category.links.collect {|l| l.category_id})
    .online.public.order(order).includes([:offers])
    .paginate(:page => page, :per_page => per_page)
  end

  #czy uzytkownik moze zlozyc oferte
  def allowed_to_offer? user
    return false if self.owner.eql?(user)

    #todo dwa razy .count czy raz .all?
    offers = self.offers.select {|offer| offer.offerer.eql?(user)}

    #niepotrzebne ale w wiekszosci przypadkow zakonczy sprawdzanie przed czasem
    return true if is_public? && offers.empty?

    #jesli zaproszony do aukcji
    false
  end
  
  def rate user, value
    self.rating_values.create :value => value, :user => user
  end
  
  #oblicza srednia ocene aukcji, jesli aukcja nie zostala jeszcze oceniona to metoda zwroci nil
  def rating
  	return (self.ratings_sum.to_f / self.ratings_count).ceil.to_i if (self.ratings_count > 0)
  	return nil
  end

  def rated_by? user
    if self.rating_values.where("user_id=?", user.id).exists?
      true
    else
      false
    end
  end
  
  #czy uzytkownik jest wlascicielem aukcji
  def is_owner? user
    self.owner.eql?(user)
  end
  
  #czy aukcja jest publiczna
  def is_public?
    private == false
  end
  
  #czy uzytkownik jest uprawniony do ogladania aukcji
  def is_allowed_to_see? user
    return true if is_public? || self.is_owner?(user)
    return false if (not is_public?) && user.eql?(nil)

    #sprawdzanie czy uzytkownik bierze udział w licytacji jesli jest wyzszy etap aukcji
    self.offers.latest.each{|offer| return true if offer.offerer.eql?(user) && offer.rejected == 0}
    false
  end

  #czy oferent złożył już oferte na aktualnym etapie
  def made_offer? offerer
      not self.offers.select {|offer| offer.offerer.eql?(offerer)}.empty?
  end  
  
  def self.search_by_sphinx(query = '', search_in_description = false, tags_ids = [], budgets_ids = [], page = 1, per_page = 15)

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
    #Rails.logger.info "ZAPYTANIE: "+query

    Auction.search query, 
      :field_weights => {:tags_ids => 3, :title => 2, :description => 1},
      :per_page => 15,
      :page => page,
      :sort_mode => :extended,
      :match_mode => :extended,
      :order => "@rank DESC"
  end
  
end
