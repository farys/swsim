class CategoriesLink < ActiveRecord::Base
  belongs_to :category
  belongs_to :parent, :class_name => "Category"

  validates_presence_of :category
  validates_presence_of :parent
  validates_numericality_of :level, :allow_blank => false, :only_integer => true
  validates_associated :category, :parent
=begin
  Jako parametr mozna podac obiekt 'Category' lub id kategorii
=end
  def self.link(category)
    category = Category.find(category) unless category.class.equal?(Category)
    level = 0 #zmienna przechowuje poziom zagniezdzenia
    
    #powiazanie sam ze soba
    link = self.new
    link.category = category
    link.parent = category
    link.level = level
    link.save

    #powiazania z rodzicami
    while link.parent.parent != nil
      
      level += 1
      new_link = self.new
      new_link.parent = link.parent.parent
      new_link.category = category
      new_link.level = level
      new_link.save

      link = new_link
    end
  end


=begin
  Jako parametr mozna podac obiekt 'Category' lub id kategorii
=end
  def self.unlink(category)
    category_id = (category.class.equal? Category)? category.id : category
    self.delete_all(["category_id = ?", category_id])
  end

  before_destroy :raise_exception
  def raise_exception
    #CategoriesLink.delete_all :parent_id => self.parent_id, :category_id => self.category_id, :level => self.level
    raise Exception.new "Destroy the Category or unlink if you want to delete links!"
  end
end
