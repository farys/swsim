class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :status
      t.references :group
      t.string :name
      t.integer :auction_count, :default => 0
    end
    
    create_table :auctions_tags, :id => false do |t|
      t.references :tag
      t.references :auction
    end
    
    add_index :auctions_tags, [:tag_id, :auction_id], :unique => true, :null => false
  end

  def self.down
  	remove_index :auctions_tags, [:tag_id, :auction_id]
    drop_table :tags
    drop_table :auctions_tags
  end
end
