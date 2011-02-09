class Statistic < ActiveRecord::Base
  validates_length_of :name, :maximum => 32, :allow_blank => :false
  validates_presence_of :value

end
