class Topic < ActiveRecord::Base
	belongs_to :user
	belongs_to :project
	has_many :posts, :dependent => :destroy
	
	validates :title, :length => { :in => 1..50}
	validates :content, :length => { :in => 1..1000}
end
