class CreateCommentKeywords < ActiveRecord::Migration
  def self.up
    create_table :comment_keywords do |t|
      t.integer :destination, :null => false
      t.string :name, :length =>32, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_keywords
  end
end
