class Group < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates_presence_of :name
  validates_associated :tags

  default_scope includes(:tags)
end