class Tag < ActiveRecord::Base
  STATUSES = {:active => 0, :hidden => 1}

  belongs_to :group
  has_and_belongs_to_many :auctions
  validates_inclusion_of :status, :in => STATUSES.values

  before_validation :default_attributes

  default_scope order("name ASC")
  scope :unlinked, where("(SELECT COUNT(1) FROM groups_tags WHERE groups_tags.tag_id=tags.id)=0")

  def self.from_text text   
    text.downcase!
    all.select {|t| not text[t.name].nil?}
  end

  def to_s
    self.name
  end

  def self.admin_search name, group_id = nil, page = nil
    criteria = (group_id.nil?)? self : Group.find(group_id).tags
    criteria = criteria.includes(:groups)
    criteria = criteria.where("tags.name like '%#{name}%' OR tags.id='#{name}'") unless name.empty?

    criteria.paginate :page => page, :per_page => 15
  end

  private
  def default_attributes
    self.status = STATUSES[:active] if self.status.nil?
  end
end
