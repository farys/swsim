class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.references :project, :null => false
      t.references :author, :null => false
      t.string :title, :null => false, :size => 50

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
