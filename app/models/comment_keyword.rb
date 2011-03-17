class CommentKeyword < ActiveRecord::Base
  has_many :values, :class_name => "CommentValue", :dependent => :destroy, :foreign_key => :keyword_id

  validates_length_of :name, :maximum => 32, :allow_blank => :false

  def self.create_comment_values
    self.all.collect {|k| CommentValue.new(:keyword => k)}
  end

end
