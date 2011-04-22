class ProjectFile < ActiveRecord::Base
  FILE_MAX_SIZE = 10.megabytes
  belongs_to :project
  
  validates :project_id, :presence => true
  validates :description, :length => { :in => 1..500 }
  validates_attachment_presence :project_file,
                                :message => I18n.t('general.project.project_file.must_be_set')
  validates_attachment_size :project_file,
                            :less_than => FILE_MAX_SIZE,
                            :message => "moze maksymalnie wynosic #{(FILE_MAX_SIZE/1.megabyte).round(2)} MiB"
  has_attached_file :project_file
  
  def name
  	self.project_file_file_name
  end
  
  def size
  	self.project_file_file_size
  end
end
