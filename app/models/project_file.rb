class ProjectFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  validates :project_id, :presence => true
  validates :user_id, :presence => true
  validates :name, :presence => true,
                   :length => { :within => 2..30}
  validates :size, :presence => true
  validates :type, :presence => true,
                   :length => { :within => 1..15 }
  validates :description, :presence => true,
                          :length => { :within => 10..500 }
end
