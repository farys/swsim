class CreateCommunications < ActiveRecord::Migration
  def self.up
    create_table :communications do |t|
      t.references :auction, :null => false
      t.integer :stage, :null => false
      t.text :body, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :communications
  end
end
