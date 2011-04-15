class Relationship < ActiveRecord::Base
	attr_accessible :watched_id
	
	belongs_to :watcher, :class_name => "User"
  	belongs_to :watched, :class_name => "User"
  	
  	validates :watcher_id, :presence => true
  	validates :watched_id, :presence => true
end
