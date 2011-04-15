class Role < ActiveRecord::Base 
  has_many :users, :through => :memberships
  has_many :memberships
  
  validates :name, :presence => true,
                   :length => { :in => 3..30 }
  
  def self.get_id(name)
  	Role.where(:name => name).first.id
  end
end
