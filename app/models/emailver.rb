class Emailver < ActiveRecord::Base
  belongs_to :user
=begin
	
!!Do zrobienia, na razie zakomentowane zeby db:reload przechodzil
  validates :hash, :presence => true
  validates :user_id, :presence => true
=end
end