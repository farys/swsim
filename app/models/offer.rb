class Offer < ActiveRecord::Base
  STATUS_WON = 2
  STATUS_NORMAL = 1
  STATUS_REJECTED = 0

  has_many :alerts
  belongs_to :auction, :counter_cache => true
  belongs_to :offerer, :class_name => "User"

  validates_associated :auction, :offerer
  validates_numericality_of :price
  validates_numericality_of :hours, :only_integer => true

  scope :normal, lambda { where(:status => STATUS_NORMAL) }
  scope :won, lambda { where(:status => STATUS_WON) }
  scope :rejected, lambda { where(:status => STATUS_REJECTED) }
  scope :with_status, lambda {|status| where(:status => status)}

  before_save :default_values, :on => :create

  def default_values
    self.status = STATUS_NORMAL if self.status.nil?
  end

  def reject!
    self.status = STATUS_REJECTED
    self.save!
  end
end
