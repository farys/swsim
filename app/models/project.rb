class Project < ActiveRecord::Base
  STATUSES = {:active => 0, :finished => 1}
   
	has_many :memberships
  has_many :users, :through => :memberships
  has_many :project_files, :dependent => :destroy
  belongs_to :auction
	
	validates :name, :presence => true,
	                 :length => { :in => 5..50}
	validates :owner_id, :presence => true
	validates :leader_id, :presence => true
	validates :duration, :presence => true
	validates :status, :presence => true,
	                   :inclusion => { :in => STATUSES.values }
	validates :description, :presence => true,
	                        :length => { :in => 10..2000}
		
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
	
	#dodaje uzytkownika do projektu, domyslna rola gosc, zwraca true|false
	def add_user(user_id = 0, role_id = 1)
	 	if self.member?(user_id)
	 		'uzytkownik jest juz czlonkiem projektu' #TODO obluga bledow !
	 	else
      Membership.create!(:project_id => self.id,
      											 :user_id => user_id,
      											 :role_id => role_id) ? true : false
	 	end
	end
	
	#usuwa uzytkownika z projektu, zwraca true|false 	
  def remove_user(user_id)
    if self.member? user_id
    	if user_id == self.owner_id
    		'nie mozna usunac wlasciciela projektu'
    	elsif user_id == self.leader_id
    		'nie mozna usunac lidera projektu'
    	else
    		self.find_membership(user_id).destroy ? true : false
    	end
   	else
   	 	'uzytkownik nie uczestniczy w prjekcie'
 	 	end  
  end
  
  #zwraca role uzytkownika w projekcie
  def user_role(user_id = 0)
  	if self.member? user_id
  		Role.find(self.find_membership(user_id).role_id)
  	else
  		'uzytkownik nie uczestniczy w projekcie'
  	end
  end
  
  #ustawia role uzytkownika, domyslnie gosc, zwraca true|false
  def set_user_role(user_id = 0, role_id = 1)
  	if self.member?(user_id)
  		if Role.exists? role_id
  			memb = self.find_membership(user_id)
  			memb.role_id = role_id
  			memb.save! ? true : false
  		else
  			'nie ma takiej roli'
  		end
  	else
  		'uzytkownik nie jest czlonkiem projketu'
  	end 	
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
		self.add_user(self.owner_id, 3)
		self.add_user(self.leader_id, 2)
	end
	
	def set_default_status
    self.status = STATUSES[:active] if self.status.nil?
  end
end