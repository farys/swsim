class CreateProjectFiles < ActiveRecord::Migration
  def self.up
    create_table :project_files do |t|
      t.references :project, :null => false
      t.text :description, :null => false, :length => 500
      t.string :project_file_file_name
      t.integer :project_file_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :project_files
  end
end
