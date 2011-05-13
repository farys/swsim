class Reputation < ActiveRecord::Base
	attr_accessible :reputation, :user_id, :finished_auctions, :auctions_overall_ratings, :rated_projects, :projects_overall_ratings, :average_contact, :average_realization, :average_attitude
	
	belongs_to :user
	
	validates_numericality_of :reputation, :presence => true
	validates_numericality_of :user_id, :presence => true, :uniqueness => true
end