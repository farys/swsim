class Bonuspoint < ActiveRecord::Base
	attr_accessible :points, :for_what, :user_id
	
	belongs_to :user
	
	validates_numericality_of :points, :presence => true
	validates_numericality_of :for_what, :presence => true
	
	default_scope :order => 'bonuspoints.created_at DESC'
	
	#for_what: 1 - bought, 2 - for blogpost, 3 - for reference user, 4 - admin
	def self.use!(points, user_id, for_what)
		create!(:points => points, :user_id => user_id, :for_what => for_what)
	end
end
