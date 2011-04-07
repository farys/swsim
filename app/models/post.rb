class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :topic
	
	validates :content, :length => { :in => 1..1000}
end
