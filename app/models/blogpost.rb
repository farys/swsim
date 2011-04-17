class Blogpost < ActiveRecord::Base
	attr_accessible :content, :title

	belongs_to :user
	
	validates :title, :presence => true
	validates :content, :presence => true
  	validates :user_id, :presence => true
	
	default_scope :order => 'blogposts.created_at DESC'
end
