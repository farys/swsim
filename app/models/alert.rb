class Alert < ActiveRecord::Base
  STATUS_UNREAD = 0
  STATUS_READ = 1
  
  belongs_to :author, :class_name => "User"
  belongs_to :reader, :class_name => "User"
  belongs_to :model, :polymorphic => true

  validates :topic, :presence => true
  validates :text, :presence => true

  before_save :default_data, :on => :create

  def default_data
    self.status = STATUS_UNREAD
  end

  def read!
    self.status = STATUS_READ
    self.save
  end

  #zgloszenie o odrzucenie oferty
  def self.offer_to_reject! offer, text
    a = Alert.new :model => offer, :author => offer.offerer, :reader => offer.auction.owner
    a.text = "Uzytkownik #{link_to offer.offerer.to_s, user_path(offer.offerer)} prosi o odrzucenie jego oferty."
    a.text += "<br />Powod:<br /> #{text}" unless text.nil? || text.empty?
    a.save!
  end

  #odpowiedz na zgloszenie o odrzucenie oferty
  def self.offer_to_reject_response! offer, decision
    a = Alert.new :model => offer, :author => offer.auction.owner, :reader => offer.offerer

    case decision
    when true
      #wyslanie komunikatu o zgodzie
      a.text = "Uzytkownik #{link_to offer.auction.owner.to_s, user_path(offer.auction.owner)} zgodzil sie odrzucic Twoja oferte. Twoja oferta zostala odrzucona."
    when false
      #wyslanie komunikatu o nie zgodzie
      a.text = "Wlasciciel aukcji #{link_to offer.auction.to_s, auction_path(offer.auction)} nie wyrazil zgodzy na odrzucenie oferty."
    end
    a.save!
  end
end
