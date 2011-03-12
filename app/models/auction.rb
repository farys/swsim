class Auction < ActiveRecord::Base
  STATUSES = {:active => 0, :finished => 1, :canceled => 2}
  MAX_EXPIRED_AFTER = 14
  ORDER_MODES = [
    ["po nazwie", "title DESC", 0],
    ["po statusie", "status ASC", 1],
    ["po ID malejaco", "id DESC", 2],
    ["po ID rosnaco", "id ASC", 3],
    ["po OCENIE malejaco", "rating DESC", 4],
    ["po OCENIE rosnaco", "rating ASC", 5]
    ]

  belongs_to :owner, :class_name => 'User'
  belongs_to :won_offer, :class_name => 'Offer', :include => [:offerer] #has_and_belongs_to?
  has_many :offers, :dependent => :destroy
  has_many :communications, :dependent => :delete_all, :order => 'id DESC'
  has_and_belongs_to_many :tags,
    :after_add => :tag_counter_up,
    :after_remove => :tag_counter_down

  has_many :rating_values, :class_name => 'AuctionRating', :dependent => :delete_all,
    :after_add => :calculate_rating,
    :after_remove => :calculate_rating
  
  define_index do
    indexes :title
    indexes :description
    indexes :budget_id
    indexes tags(:id), :as => :tags_ids
    has :expired_at
    where 'auctions.private = 0 AND auctions.expired_at > NOW()'
  end

  validates :title, :presence => true, :length => { :within => 5..50}
  validates :description, :presence => true
  validates_inclusion_of :status, :in => STATUSES.values
  validates_inclusion_of :budget_id, :in => Budget.ids
  validates :won_offer, :presence => true, :on => :update

  scope :has_tags, lambda { |tags| {:conditions => ['id in (SELECT auction_id FROM auctions_tags WHERE tag_id in (?))', tags.join(',')]}}
  scope :with_status, lambda { |status| where(:status => STATUSES[status.to_sym])}
  scope :online, lambda { where(:status => STATUSES[:active])}
  scope :public_auctions, lambda { where(:private => false)}
  
  before_validation :init_auction_row, :on => :create
  before_update :won_offer_choosed, :if => :won_offer_id_changed?
  before_update :status_changed, :if => :is_down?

  #create form
  attr_accessor :expired_after
  validates_inclusion_of :expired_after, :in => (1..MAX_EXPIRED_AFTER).to_a.collect{|d| d}, :on => :create
  
  def to_s
    self.title
  end

  #ustawia status aukcji na anulowano
  def cancel!
    self.expired_at = DateTime.now
    self.status = STATUSES[:canceled]
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

  def rated_by? user
    self.rating_values.where("user_id=?", user.id).exists?
  end

  def status?(status)
    self.status == STATUSES[status.to_sym]
  end

  def won_offer_exists?
    self.won_offer_id != nil
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
  
  def self.search_by_sphinx(query = '', search_in_description = false, tags_ids = [], budget_ids = [], order = nil, page = 1, per_page = 15)

    unless search_in_description || query.length == 0
      query = '@title ' + query
    end
    
    unless tags_ids.empty?
      #options.merge! :weights => {:tag_list => 2}
      query += ' @tags_ids '+tags_ids.join(' | ')+''
    end
    
    unless budget_ids.empty?
      #options.merge! :weights => {:tag_list => 2}
      query += ' @budget_id '+budget_ids.join(' | ')+''
    end
    now = DateTime.now

    Auction.search query, 
      :field_weights => {:tags_ids => 3, :title => 2, :description => 1},
      :per_page => per_page,
      :page => page,
      :sort_mode => :extended,
      :match_mode => :extended,
      :with => {:expired_at => now..(now+MAX_EXPIRED_AFTER.days)},
      :order => order || "@rank DESC"
  end
  
  def new_offer params
    self.offers.new params do |o|
      o.status = Offer::STATUSES[:active]
    end
  end

  #wyszukiwanie aukcji dla admina
  def self.admin_search(query = "", selected_date = nil, status = Array.new, order = 0, page = 1)
    criteria = self.includes(:owner)
    criteria.order(ORDER_MODES[order][1])
    
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

  def update_offers params
    return true if params.nil?
    
    saved = true
    self.offers.each do |offer|
      offer_id = offer.id.to_s
      if params.has_key? offer_id
        save = offer.update_attributes(params[offer_id])
        saved = false if save == false
      end
    end
    saved
  end

  private
  def is_down?
    self.status_changed? && [STATUSES[:canceled], STATUSES[:finished]].include?(self.status)
  end
  
  def init_auction_row
    self.expired_after = self.expired_after.to_i
    self.expired_at = DateTime.now + self.expired_after.days
    self.status = STATUSES[:active]
  end

  def tag_counter_up tag
    tag.increment! :auction_count
  end

  def tag_counter_down tag
    tag.decrement! :auction_count
  end

  def won_offer_choosed
    unless self.offers.find(self.won_offer_id)
      self.errors.add("won_offer_id", "Wybrana oferta nie nalezy do ofert uczestniczacych w licytacji")
    else
      self.status = STATUSES[:finished]

      self.won_offer.status = Offer::STATUSES[:won]
      self.won_offer.save
    end
  end

  def status_changed
    self.expired_at = DateTime.now
    self.tags.delete_all
  end

  def calculate_rating(v1)
    self.update_attribute(:rating, self.rating_values.sum(:value) / self.rating_values.count)
  end
end
