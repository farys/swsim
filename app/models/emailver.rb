class Emailver < ActiveRecord::Base
	attr_accessible :hash, :user_id
  belongs_to :user

  validates :hash, :presence => true
  validates :user_id, :presence => true
end