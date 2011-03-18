class CreateCommentValues < ActiveRecord::Migration
  def self.up
    create_table :comment_values, :id => false do |t|
      t.references :comment, :null => false
      t.references :keyword, :null => false
      t.string :extra, :length => 255
      t.integer :rating, :null => false
    end
    
    add_index :comment_values, :comment_id
  end

  def self.down
    drop_table :comment_values
  end
end
