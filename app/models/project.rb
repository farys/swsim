class Project < ActiveRecord::Base
  STATUSES = {:active => 0, :finished => 1}
   
	has_many :memberships
  has_many :users, :through => :memberships
  has_many :project_files, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
  has_many :tickets, :dependent => :destroy
  belongs_to :auction
	
	validates :name, :length => { :in => 5..50}
	validates :owner_id, :presence => true
	validates :leader_id, :presence => true
	validates :duration, :presence => true
	validates :status, :inclusion => { :in => STATUSES.values }
	validates :description, :length => { :in => 10..2000}
		
	default_scope :order => 'projects.id DESC'
	
	before_validation :set_default_status, :on => :create
	after_create :add_default_users
	
	#zwraca date zakonczenia projektu
	def deadline
	  self.created_at + self.duration.days
	end
	
	#zwraca czas ktory pozostal do zakonczenia projektu
	def time_left
	  self.deadline - DateTime.now
	end
	 
  #zwraca role uzytkownika w projekcie
  def user_role(user_id = 0)
  		Role.find(self.find_membership(user_id).role_id)
  end

  #zwraca obiekt membership
  def find_membership(user_id = 0)
  	Membership.where("project_id = ? AND user_id = ?", self, user_id).first
  end
  
  #sprawdza czy uzytkownik jest czlonkiem projektu, zwraca (true|false)
  def member? (user_id = 0)
  	self.user_ids.include?(user_id)
  end
  
  #sprawdza czy projekt jest aktywny, zwraca(true|false)
  def active?
    return self.status == STATUSES[:active] ? true : false
  end

  private 
	
	def add_default_users
		Membership.create!(:project_id => self.id,
      								 :user_id => self.owner_id,
      								 :role_id => Role.get_id('owner'))
    Membership.create!(:project_id => self.id,
      								 :user_id => self.leader_id,
      								 :role_id => Role.get_id('leader'))
	end
	
	def set_default_status
    self.status = STATUSES[:active] if self.status.nil?
  end
end
