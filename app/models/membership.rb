class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :role
  
  validates :project_id, :presence => true
  validates :user_id, :presence => true
  validates :role_id, :presence => true

end
