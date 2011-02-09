class CreateCategoriesLinks < ActiveRecord::Migration
  def self.up
    create_table :categories_links, :id => false do |t|
      t.references :parent, :null => false
      t.references :category, :null => false
      t.integer :level, :null => false
    end
  end

  def self.down
    drop_table :categories_links
  end
end
