class Team < ActiveRecord::Base
  has_many :sent_offers, :as => :offerer, :class_name => "Offer", :foreign_key => :oferrer_id
end
