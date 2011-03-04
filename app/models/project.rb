#encoding: utf-8 
class Project < ActiveRecord::Base
  STATUS_ACTIVE = 0
  STATUS_CANCELED = 1
  STATUS_FINISHED = 2
  
	belongs_to :owner, :class_name => 'User'
	
	validates :name, :presence => true,
	                 :length => { :within => 5..50}
	validates :owner_id, :presence => true
	validates :leader_id, :presence => true
	validates :duration, :presence => true
	validates :status, :presence => true,
	                   :inclusion => { :in => [Project::STATUS_ACTIVE, Project::STATUS_CANCELED, Project::STATUS_FINISHED] }
	
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
end