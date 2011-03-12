class User < ActiveRecord::Base
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
  has_many :project_files, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  string = /\A[\w+\-.]+\z/
	
	validates :login, :presence => true, :format => {:with => string}, :length => {:within => 3..40}, :uniqueness => true
	validates :name, :presence => true, :format => {:with => string}, :length => {:within => 1..40}
	validates :lastname, :presence => true, :format => {:with => string}, :length => {:within => 3..40}
	validates :country, :presence => true
	validates :email, :presence => true, :format => {:with => email_regex}, :uniqueness => { :case_sensitive => false }, :length => {:within => 6..50}
	validates :password, :presence => true, :confirmation => true, :length => { :within => 6..40 }
	validates_numericality_of :status, :presence => true
	validates_inclusion_of :role, :in => ["administrator", "user"]
	
	before_save :encrypt_password
  
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