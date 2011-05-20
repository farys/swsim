# encoding: utf-8
#require 'paperclip'
class User < ActiveRecord::Base
  attr_accessible :login, :name, :lastname, :email, :country, :status, :role, :password, :password_confirmation, :description, :avatar
  
	has_attached_file :avatar, :styles => { :thumb => "100x100>" }, :default_url => "/images/avatars/missing.png"
	
  has_many :sent_alerts, :class_name => 'Alert',:foreign_key => :author_id
  has_many :received_alerts, :class_name => 'Alert',:foreign_key => :reader_id
  has_many :auctions, :foreign_key => :owner_id, :include => [:won_offer]
  has_many :won_in_auctions, :class_name => 'Auction', :as => :winner
  has_many :messages, :foreign_key => :owner_id, :order => 'id DESC'
  has_many :written_comments, :class_name => 'Comment', :foreign_key => :author_id
  has_many :received_comments, :class_name => 'Comment', :foreign_key => :receiver_id
  has_many :sent_offers, :class_name => 'Offer', :foreign_key => :offerer_id
  has_many :rated_values, :class_name => 'AuctionRating', :dependent => :delete_all
  has_many :memberships, :dependent => :destroy
  has_many :projects, :through => :memberships
  has_many :roles, :through => :memberships
  has_one :emailver
  has_one :reputation, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
  has_many :relationships, :foreign_key => "watcher_id", :dependent => :destroy
  has_many :watching, :through => :relationships, :source => :watched
  has_many :reverse_relationships, :foreign_key => "watched_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :watchers, :through => :reverse_relationships, :source => :watcher
  has_many :blogposts
  has_many :blogcomments, :dependent => :destroy
  has_many :bonuspoints, :dependent => :destroy
  has_many :tickets
  has_many :usefuls
  
  email_regex = /\A[\w+żźćńółęąśŻŹĆĄŚĘŁÓŃ\-.]+@[a-zżźćńółęąś\d\-.]+\.[a-z]+\z/i
  string = /\A[\w+żźćńółęąśŻŹĆĄŚĘŁÓŃß\-.]+\z/
	
	validates :login, :presence => true, :format => {:with => string}, :length => {:within => 1..40}, :uniqueness => true
	validates :name, :presence => true, :format => {:with => string}, :length => {:within => 1..40} #zmienilem od 1 bo Faker mi generowal first_name < 3 znakow
	validates :lastname, :presence => true, :format => {:with => string}, :length => {:within => 1..40}
	validates :country, :presence => true
	validates :email, :presence => true, :format => {:with => email_regex}, :uniqueness => { :case_sensitive => false }, :length => {:within => 6..50}
	validates :password, :presence => true, :confirmation => true, :length => { :within => 5..100 }
	validates_numericality_of :status, :presence => true
	validates_inclusion_of :role, :in => ["administrator", "user"]
	
	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png', 'image/gif']

	before_create :encrypt_password
	before_create :default_data
	before_update :encrypt_password, :if => ->{ self.password_changed? }

  def default_data
 	self.status = 1
	self.role = "user"
  end
	
  def watching?(watched)
    relationships.find_by_watched_id(watched)
  end

  def watch!(watched)
    relationships.create!(:watched_id => watched.id)
  end
  
  def unwatch!(watched)
    relationships.find_by_watched_id(watched).destroy
  end
 
  def to_s
    self.login
  end
  
  def new_message params
    msg = self.messages.new params
    msg.author_id = self.id
    msg
  end
  
  def find_messages folder, page
    unless [:received, :sent].include? folder
      raise Exception.new('Niepoprawny typ wiadomosci')
    end
    
    self.messages.send(folder).paginate(:page => page, :per_page => 15)    
  end
  
    def has_password?(submitted_password)
	    password == encrypt(submitted_password)
    end
     
    def self.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil  if user.nil?
      return user if user.has_password?(submitted_password)
    end
    
    def self.authenticate_with_salt(id, cookie_salt)
	    user = find_by_id(id)
	    (user && user.salt == cookie_salt) ? user : nil
    end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end
