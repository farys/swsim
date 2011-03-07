class Offer < ActiveRecord::Base
  STATUSES = {:won => 2, :active => 1, :rejected => 0}

  has_many :alerts
  belongs_to :auction, :counter_cache => true
  belongs_to :offerer, :class_name => "User"

  validates_associated :auction, :offerer
  validates_numericality_of :price
  validates_numericality_of :days, :only_integer => true

  scope :normal, lambda { where(:status => STATUSES[:active]) }
  scope :won, lambda { where(:status => STATUSES[:won]) }
  scope :rejected, lambda { where(:status => STATUSES[:rejected]) }
  scope :with_status, lambda {|status| where(:status => STATUSES[status])}

  before_save :default_values, :on => :create

  def default_values
    self.status = STATUSES[:active] if self.status.nil?
  end

  def reject!
    self.status = STATUSES[:rejected]
    self.save
  end

  def recovery!
    self.status = STATUSES[:active]
    self.save
  end
end
