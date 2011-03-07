class Membership < ActiveRecord::Base
  belongs_to :users
  belongs_to :projects
  
  validates_presence_of :project_id, :user_id
end
