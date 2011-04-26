class Blogpost < ActiveRecord::Base
	attr_accessible :content, :title

	belongs_to :user
	has_many :blogcomments, :dependent => :destroy
	
	validates :title, :presence => true
	validates :content, :presence => true
  	validates :user_id, :presence => true
	
	default_scope :order => 'blogposts.created_at DESC'
end
