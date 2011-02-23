class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.references :author, :null => false
      t.references :reader
      t.references :model, :polymorphic => true
      t.text :text, :length => 500

      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
