class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :auction
      t.references :project
      t.references :author, :null => false
      t.references :receiver, :null => false
      t.integer :level
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
