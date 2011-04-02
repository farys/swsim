class ProjectFile < ActiveRecord::Base
  belongs_to :project
  
  validates :project_id, :presence => true
  validates :name, :length => { :in => 2..30}
  validates :size, :presence => true
  validates :extension, :length => { :in => 1..15 }
  validates :description, :length => { :in => 10..500 }
end
