class Ticket < ActiveRecord::Base
  STATUSES = {:free => 0, :implementation => 1, :finished => 2}
  
  belongs_to :project
  belongs_to :user
  
  validates :project_id, :presence => true
  validates :title, :length => {:in => 5..40}
  validates :description, :length => {:in => 10..2000}
  validates_numericality_of :duration, :only_integer => true,
                                       :greater_than => 0
  validates :status, :inclusion => { :in => STATUSES.values }
  
  default_scope :order => 'tickets.status ASC'
end
