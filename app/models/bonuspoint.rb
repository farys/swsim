class Bonuspoint < ActiveRecord::Base
	attr_accessible :points, :for_what, :user_id
	
	belongs_to :user
	
	validates_numericality_of :points, :presence => true
	validates_numericality_of :for_what, :presence => true
	
	default_scope :order => 'bonuspoints.created_at DESC'
end
