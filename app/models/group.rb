class Group < ActiveRecord::Base
  STATUSES = {:active => 0, :hidden => 1}
  
  has_many :tags, :dependent => :destroy

  validates :name, :presence => true
  validates_associated :tags

  default_scope order("name ASC").includes(:tags)

  def to_s
    self.name
  end

  def self.admin_array_to_select
    self.select("id, name").all.collect do |group|
      [group.name, group.id]
    end
  end

  def self.array_to_select
    self.select("id, name").where(:status => STATUSES[:active]).collect do |group|
      [group.name, group.id]
    end
  end
end