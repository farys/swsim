#TODO zmienic na lepsza nazwe
class Communication < ActiveRecord::Base
  belongs_to :auction
  
  validates_length_of :body, :within => 10..5000
end
