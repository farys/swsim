class CreateProjectFiles < ActiveRecord::Migration
  def self.up
    create_table :project_files do |t|
      t.references :project, :null => false
      t.references :user, :null => false
      t.string :name, :null => false, :length => 30
      t.decimal :size, :null => false
      t.string :type, :null => false, :length => 15
      t.text :description, :null => false, :length => 500

      t.timestamps
    end
  end

  def self.down
    drop_table :project_files
  end
end
