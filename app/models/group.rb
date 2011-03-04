class Group < ActiveRecord::Base
  STATUS_ACTIVE = 0
  STATUS_HIDDEN = 1
  
  has_and_belongs_to_many :tags

  validates :name, :presence => true
  validates_associated :tags

  default_scope includes(:tags)

  def to_s
    self.name
  end
end