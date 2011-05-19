class Useful < ActiveRecord::Base
	attr_accessible :user_id, :blogpost_id
	
	belongs_to :blogpost
	belongs_to :user
	
	validates :user_id, :presence => true
	validates :blogpost_id, :presence => true
	
	def self.use!(blogpost_id, user_id)
		create!(:blogpost_id => blogpost_id, :user_id => user_id)
	end
end
