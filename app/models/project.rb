class Project < ActiveRecord::Base
  STATUSES = {:active => 0, :finished => 1}
   
	has_many :memberships
  has_many :users, :through => :memberships
  has_many :project_files, :dependent => :destroy
	
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
	
	def deadline
	  self.created_at + self.duration.days
	end
	
	def time_left
	  self.deadline - DateTime.now
	end
	
	 def add_user(user_id)
    memberships.create(:project_id => self.id, :user_id => user_id)
  end
  
  def remove_user(user_id)
    memberships.find_by_user_id(user_id).destroy
  end
  
  def set_user_role(user_id, role_id)
    membership = Membership.where("project_id = ? AND user_id = ?", self.id, user_id)
    if membership.empty? && membership.count != 1
      'nie ma takiego usera'
    else
      membership.first.role_id=role_id
    end  
  end
   
  private 
	
	def add_default_users
	  Membership.create(:project_id => self.id, :user_id => self.owner_id, :role_id => 3)
	  Membership.create(:project_id => self.id, :user_id => self.leader_id, :role_id => 2)
	end
	
	def set_default_status
    self.status = STATUSES[:active] if self.status.nil?
  end
end