class CreateBudget < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
    	t.string :title
    end
  end

  def self.down
    drop_table :budgets
  end
end
