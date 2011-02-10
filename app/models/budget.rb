# encoding: utf-8 

class BudgetRecord
  def initialize(id, title)
    @id = id
    @title = title
  end

  def to_s
    @title + " zł"
  end
  attr_reader :id, :title
end

class Budget
  def self.find id
    @@budgets.select{|o| o.id == id}[0]    
  end
  
  def self.all
    @@budgets
  end
  
  def self.ids
    @@budgets.collect {|v| v.id}
  end
  
  @@budgets = [
    BudgetRecord.new(0, "0 - 500"),
    BudgetRecord.new(1, "500 - 1000")
    ]
end