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
	
	#before_create :set_default_status
	after_create :add_default_users
	
	def deadline
	  self.created_at + self.duration.days
	end
	
	def time_left
	  self.deadline - DateTime.now
	end
	
	 def add_user(user_id)
    memberships.create(:project_id => self.id, :user_id => user_id, :role_id => 0)
  end
  
  def remove_user(user_id)
    memberships.find_by_user_id(user_id).destroy
  end
  
  def set_user_role(user_id, role_id)
    memberships.find(user_id).role_id = role_id
  end

  private
  
	def set_default_status
    self.status = STATUSES[:active] if self.status.nil?
  end
	
	def add_default_users
	  self.add_user(self.owner_id)
	  #self.set_user_role(self.owner_id, 1)
	end
end