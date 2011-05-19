class Blogpost < ActiveRecord::Base
	attr_accessible :content, :title, :admin

	belongs_to :user
	has_many :blogcomments, :dependent => :destroy
	
	validates :title, :presence => true, :length => {:within => 5..40}
	validates :content, :presence => true, :length => {:within => 20..5000}
  	validates :user_id, :presence => true
	
	default_scope :order => 'blogposts.created_at DESC'
end
