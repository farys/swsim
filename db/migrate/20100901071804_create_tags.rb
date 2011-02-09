class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :auctions_tags, :id => false do |t|
      t.references :tag
      t.references :auction
    end
    
  end

  def self.down
    drop_table :tags
    drop_table :auctions_tags
  end
end
