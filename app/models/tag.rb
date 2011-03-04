class Tag < ActiveRecord::Base
  STATUS_ACTIVE = 0
  STATUS_HIDDEN = 1

  has_and_belongs_to_many :groups
  has_many :auctions

  before_save :default_data, :on => :create

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
  def default_data
    self.status = STATUS_ACTIVE
  end
end
