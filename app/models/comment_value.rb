class CommentValue < ActiveRecord::Base
  belongs_to :comment
  belongs_to :keyword, :class_name => "CommentKeyword"

  validates :extra, :length => {:maximum => 255}, :allow_blank => :true

  validates :extra, :presence => true, :if => ->{ self.rating && self.rating < 3}
  validates :rating, :presence => true, :inclusion => {:in => 1..5}
end
