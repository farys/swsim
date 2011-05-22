class Blogcomment < ActiveRecord::Base
	attr_accessible :content, :admin, :user_id, :blogpost_id
	
	belongs_to :blogpost
	belongs_to :user
	
	validates :content, :presence => true, :length => {:within => 1..200}
  	validates :user_id, :presence => true
  	validates :blogpost_id, :presence => true
  	
  	default_scope :order => 'blogcomments.created_at DESC'
end
