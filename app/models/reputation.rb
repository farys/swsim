class Reputation < ActiveRecord::Base
	attr_accessible :value, :user_id
	
	belongs_to :user
	
	validates_numericality_of :value, :presence => true
	validates_numericality_of :user_id, :presence => true
end