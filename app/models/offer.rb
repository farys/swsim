class Offer < ActiveRecord::Base
  STATUS_WON = 3
  STATUS_LATEST = 2
  STATUS_NORMAL = 1
  STATUS_REJECTED = 0

  belongs_to :auction, :counter_cache => true
  belongs_to :offerer, :polymorphic => true

  validates_associated :auction, :offerer
  validates_numericality_of :stage, :only_integer => true
  validates_numericality_of :price
  validates_numericality_of :hours, :only_integer => true

  scope :latest, -> { where("status = ?", Offer::STATUS_LATEST) }

  before_validation :set_stage_to_offer, :on => :create
  before_create :update_previous_offers
  
  def set_stage_to_offer
    self.stage = self.auction.stage
  end
  
  def update_previous_offers
    if self.stage > 1
      previous_offers = Offer.all :conditions => {
        :auction_id => self.auction_id,
        :offerer_id => self.offerer_id,
        :offerer_type => self.offerer_type
        }
        previous_offers.each do |offer|
          offer.status = Offer::STATUS_NORMAL
          offer.save
        end
    end
  end

###
## Ustawia oferty jako odrzucone
## offers_ids idki ofert do odrzucenia
###
#  def self.reject offers_ids
#    offers = self.all :conditions => ['id in (?)', offers_ids]
#
#    offers.each do |offer|
#      offer.status = STATUS_REJECTED
#      offer.save!
#    end
#  end

##
# Ustawia oferty jako odrzucone za wyjątkiem podanych ofert jako argument
# offers_id idki ofert ktore pozostana "aktywne"
##
  def self.stay_on offers_ids
    self.all.each do |offer|
      unless offers_ids.collect{|item| item.to_i}.include? offer.id
        offer.status = Offer::STATUS_REJECTED
        offer.save!
      end
    end
  end
end
