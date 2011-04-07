class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
    	t.references :topic, :null => false
    	t.references :user, :null => false
      t.text :content, :null => false, :size => 1000     

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
