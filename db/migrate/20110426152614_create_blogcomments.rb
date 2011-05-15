class CreateBlogcomments < ActiveRecord::Migration
  def self.up
    create_table :blogcomments do |t|
      t.text :content
      t.integer :blogpost_id
      t.integer :user_id, :default => 1
      t.integer :admin, :default => 0

      t.timestamps
    end
    add_index :blogcomments, :user_id
    add_index :blogcomments, :blogpost_id
  end

  def self.down
    drop_table :blogcomments
  end
end
