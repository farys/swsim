#TODO zmienic na lepsza nazwe
class Communication < ActiveRecord::Base
  belongs_to :auction
  
  validates_length_of :body, :within => 10..5000
  validates_associated :auction

  def before_validation_on_create
    self.stage = self.auction.stage
  end
end
