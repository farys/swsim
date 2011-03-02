class Auction < ActiveRecord::Base
  STATUS_ACTIVE = 0
  STATUS_CANCELED = 1
  STATUS_FINISHED = 2

  belongs_to :owner, :class_name => 'User'
  belongs_to :won_offer, :class_name => 'Offer', :include => [:offerer] #has_and_belongs_to?
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
    
    where 'status = '+Auction::STATUS_ACTIVE.to_s+' AND private = 0'
  end

  validates :title, :presence => true
  validates :description, :presence => true
  validates_inclusion_of :status, :in => [Auction::STATUS_ACTIVE, Auction::STATUS_CANCELED, Auction::STATUS_FINISHED]
  validates_inclusion_of :budget_id, :in => Budget.ids
  validates_associated :tags, :owner
  
  scope :has_tags, lambda { |tags| {:conditions => ['id in (SELECT auction_id FROM auctions_tags WHERE tag_id in (?))', tags.join(',')]}}
  scope :with_status, lambda { |status| where(:status => status)}
  scope :online, lambda { where(:status => Auction::STATUS_ACTIVE)}
  scope :public_auctions, lambda { where(:private => false)}
  
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
    self.status = Auction::STATUS_ACTIVE
  end

  def won_offer_choosed
    unless self.offers.find(self.won_offer_id)
      self.errors.add("won_offer_id", "Wybrana oferta nie nalezy do ofert uczestniczacych w licytacji")
    else
      self.status = Auction::STATUS_FINISHED
    end
  end
  
  def status_changed
    self.expired = DateTime.now
  end

  #ustawia status aukcji na anulowano
  def cancel!
    self.status = STATUS_CANCELED
    self.save
  end

  def set_won_offer! offer_id
    self.won_offer_id = offer_id
    self.save
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

    Auction.search query, 
      :field_weights => {:tags_ids => 3, :title => 2, :description => 1},
      :per_page => 15,
      :page => page,
      :sort_mode => :extended,
      :match_mode => :extended,
      :order => "@rank DESC"
  end
  
  def new_offer params
    self.offers.new params do |o|
      o.status = Offer::STATUS_ACTIVE
    end
  end

  #wyszukiwanie aukcji dla admina
  def self.admin_search(query = "", selected_date = nil, status = Array.new, page = 1)
    criteria = self.includes(:owner).order("id DESC")

    unless query.empty?
      criteria = criteria.where("auctions.title like ? OR auctions.id=?", "%#{query}%", query)
    end

    unless selected_date.nil?
      criteria = criteria.where("DATE(auctions.created_at)=?", selected_date)
    end

    unless status.empty?
      criteria = criteria.where(:status => status)
    end

    criteria.paginate(:per_page => 15, :page => page)
  end
end
