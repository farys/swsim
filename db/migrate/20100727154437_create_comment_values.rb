class CreateCommentValues < ActiveRecord::Migration
  def self.up
    create_table :comment_values do |t|
      t.references :comment, :null => false
      t.references :keyword, :null => false
      t.string :extra, :length => 255
      t.integer :status, :null => false #positive, negative

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_values
  end
end
