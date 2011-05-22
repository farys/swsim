class Alert < ActiveRecord::Base
  STATUSES = {:unread => 0, :read => 1}

  attr_accessible :text

  belongs_to :author, :class_name => "User"
  validates :text, :presence => true

  before_save :default_data, :on => :create

  def read!
    self.status = STATUSES[:read]
    self.save
  end

  private
  def default_data
    self.status = STATUSES[:unread]
  end
end
