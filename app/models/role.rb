class Role < ActiveRecord::Base
  has_many :users, :through => :memberships
  has_many :memberships
  
  validates :name, :presence => true,
                   :length => { :in => 3..30 }
  #validates :file, :presence => true
  #validates :forum, :presence => true
  #validates :info, :presence => true
  #validates :user, :presence => true
end
