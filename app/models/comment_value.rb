class CommentValue < ActiveRecord::Base
  belongs_to :comment
  belongs_to :keyword, :class_name => "CommentKeyword"

  validates_length_of :extra, :maximum => 255, :allow_blank => :true
  validates_associated :comment, :keyword
end
