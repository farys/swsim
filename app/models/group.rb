class Group < ActiveRecord::Base
  STATUSES = {:active => 0, :hidden => 1}
  
  has_and_belongs_to_many :tags

  validates :name, :presence => true
  validates_associated :tags

  default_scope includes(:tags)

  def to_s
    self.name
  end
end