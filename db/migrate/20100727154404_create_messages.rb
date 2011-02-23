class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :owner, :null => false
      t.references :author, :null => false
      t.references :receiver, :null => false
      t.integer :status, :null => false, :default => 2
      t.text :body, :length => 500
      t.string :topic, :length => 128, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
