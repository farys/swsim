class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.references :project, :null => false
      t.references :user, :null => false
      t.string :title, :null => false, :size => 50
      t.text :content, :null => false, :size => 1000

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
