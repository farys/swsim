class Topic < ActiveRecord::Base
	belongs_to :user
	belongs_to :project
	has_many :posts, :dependent => :destroy
	
	validates :title, :length => { :in => 5..50}
	validates :content, :length => { :in => 10..1000}
end
