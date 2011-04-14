class Invitation < ActiveRecord::Base
  STATUSES = {:accepted => 0, :pending => 1, :rejected => 2, :canceled => 3}
  
  belongs_to :project
  belongs_to :user
  
  validates :status, :inclusion => { :in => STATUSES.values }
  
  before_validation :set_default_status, :on => :create
  
  private
  
  def set_default_status
    self.status = STATUSES[:pending] if self.status.nil?
  end
end
