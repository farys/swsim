class Blogcomment < ActiveRecord::Base
	attr_accessible :content
	
	belongs_to :blogpost
	belongs_to :user
	
	validates :content, :presence => true
  	validates :user_id, :presence => true
  	validates :blogpost_id, :presence => true
  	
  	default_scope :order => 'blogcomments.created_at ASC'
end