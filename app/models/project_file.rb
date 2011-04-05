class ProjectFile < ActiveRecord::Base
  belongs_to :project
  
  validates :project_id, :presence => true
  validates :description, :length => { :in => 10..500 }
  validates_attachment_presence(:project_file)
  validates_attachment_size(:project_file, {:in => 1..10.megabytes})
  
  has_attached_file :project_file
  
  def name
  	self.project_file_file_name
  end
  
  def size
  	self.project_file_file_size
  end
end
