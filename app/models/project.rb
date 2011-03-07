 #encoding: utf-8 
class Project < ActiveRecord::Base
  STATUS_ACTIVE = 0
  STATUS_CANCELED = 1
  STATUS_FINISHED = 2
  
	has_many :memberships
  has_many :users, :through => :memberships
	
	validates :name, :presence => true,
	                 :length => { :within => 5..50}
	validates :owner_id, :presence => true
	validates :leader_id, :presence => true
	validates :duration, :presence => true
	validates :status, :presence => true,
	                   :inclusion => { :in => [Project::STATUS_ACTIVE, Project::STATUS_CANCELED, Project::STATUS_FINISHED] }
	
	default_scope :order => 'projects.id DESC'
	
	#before_create :set_default_status
	after_create :add_default_users
	
	def string_status
	  case self.status
	  when STATUS_ACTIVE
	    'Aktywny'
	  when STATUS_CANCELED
	    'Anulowany'
	  when STATUS_FINISHED
	    'Zakończony'
	  end
	end
	
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
    memberships.find(user_id).role_id = role_id
  end
  
  private
	def set_default_status
	  self.status = STATUS_ACTIVE
	end
	
	def add_default_users
	  self.add_user(self.owner_id)
	  #self.set_user_role(self.owner_id, 1)
	end
end