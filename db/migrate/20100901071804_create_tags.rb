class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end
    
    create_table :auctions_tags, :id => false do |t|
      t.references :tag
      t.references :auction
    end

    create_table :groups_tags, :id => false do |t|
      t.references :tag, :unique => true
      t.references :group
    end
    
    add_index :auctions_tags, [:tag_id, :auction_id], :unique => true, :null => false
    add_index :groups_tags, [:group_id, :tag_id], :unique => true, :null => false
  end

  def self.down
  	remove_index :auctions_tags, [:tag_id, :auction_id]
    remove_index :groups_tags, [:group_id, :tag_id]
    drop_table :tags
    drop_table :auctions_tags
    drop_table :groups_tags
  end
end
