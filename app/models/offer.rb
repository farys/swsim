class Offer < ActiveRecord::Base
  STATUS_WON = 2
  STATUS_NORMAL = 1
  STATUS_REJECTED = 0

  belongs_to :auction, :counter_cache => true
  belongs_to :offerer, :polymorphic => true

  validates_associated :auction, :offerer
  validates_numericality_of :price
  validates_numericality_of :hours, :only_integer => true

  scope :normal, lambda { where(:status => Offer::STATUS_NORMAL) }
  scope :won, lambda { where(:status => Offer::STATUS_WON) }
  scope :rejected, lambda { where(:status => Offer::STATUS_REJECTED) }
  scope :with_status, lambda {|status = -1| where(:status => status) unless status.eql?(-1)} 
end
