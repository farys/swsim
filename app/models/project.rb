class Project < ActiveRecord::Base
  STATUS_ACTIVE = 0
  STATUS_CANCELED = 1
  STATUS_FINISHED = 2
  
	belongs_to :owner, :class_name => 'User'
	
	validates :name, :presence => true,
	                 :length => { :within => 5..50}
	validates :owner_id, :presence => true
	validates :leader_id, :presence => true
	validates :deadline, :presence => true
	validates :status, :presence => true,
	                   :inclusion => { :in => [Project::STATUS_ACTIVE, Project::STATUS_CANCELED, Project::STATUS_FINISHED] }
	
end