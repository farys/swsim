class CreateCommentKeywords < ActiveRecord::Migration
  def self.up
    create_table :comment_keywords do |t|
      t.string :name, :length =>32, :null => false
    end
  end

  def self.down
    drop_table :comment_keywords
  end
end
