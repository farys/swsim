class Alert < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  belongs_to :reader, :class_name => "User"

  validates_presence_of :text
  validates_associated :author
end
