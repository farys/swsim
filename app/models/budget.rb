# encoding: utf-8

class Budget < ActiveRecord::Base
  def to_s
    self.title
  end

  def self.ids
    self.all.collect {|b| b.id}
  end
end