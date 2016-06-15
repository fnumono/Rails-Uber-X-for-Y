class AddFundsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :funds, :decimal, default: 0
    add_column :tasks, :funds_details, :string
    add_column :tasks, :unit, :string
  end
end
