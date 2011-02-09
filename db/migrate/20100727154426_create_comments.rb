class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :auction, :null => false
      t.references :author, :null => false
      t.references :receiver, :null => false
      t.references :team
      t.decimal :mark
      t.integer :status, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
