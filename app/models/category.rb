class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => "Category"
  has_many :links, :class_name => "CategoriesLink", :foreign_key => :parent_id, :dependent => :delete_all
  has_many :parent_links, :class_name => "CategoriesLink", :foreign_key => :category_id, :order => "level DESC"
  has_many :children, :class_name => "Category", :foreign_key => :parent_id, :dependent => :destroy
  has_many :auctions

  validates_presence_of :name
  validates_associated :parent
  
  after_save :refresh_links
  def refresh_links
    CategoriesLink.unlink(self)
    CategoriesLink.link(self)
  end

  def self.get_array ids = nil
    options = {:include => [:parent_links, :children]}

    categories = case ids.nil?
      when true
          Category.all(options)
      when false
          Category.find(ids, options)
    end

    result = Array.new

    categories.each do |c|
      result.push [c.parent_links.collect {|l| l.parent.name}.join(" > "), c.id] if c.children.empty? #children_count w categories?
    end

      result.sort {|a,b| a[0] <=> b[0]}
  end
end
