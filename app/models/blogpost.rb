class Blogpost < ActiveRecord::Base
	attr_accessible :content, :title, :admin

	belongs_to :user
	has_many :blogcomments, :dependent => :destroy
	has_many :usefuls, :dependent => :destroy
	
	validates :title, :presence => true, :length => {:within => 5..100}
	validates :content, :presence => true, :length => {:within => 10..5000}
  	validates :user_id, :presence => true
	
	default_scope :order => 'blogposts.created_at DESC'
end
