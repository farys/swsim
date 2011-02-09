class CommentKeyword < ActiveRecord::Base
  has_many :values, :class_name => "CommentValue", :dependent => :destroy, :foreign_key => :keyword_id

  validates_length_of :name, :maximum => 32, :allow_blank => :false
  validates_numericality_of :destination, :allow_blank => :false
end
