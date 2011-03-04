class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.integer :status, :null => false
      t.references :author, :null => false
      t.references :reader, :null => false
      t.references :model, :polymorphic => true, :null => false

      t.string :topic, :null => false
      t.text :text, :length => 500

      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
