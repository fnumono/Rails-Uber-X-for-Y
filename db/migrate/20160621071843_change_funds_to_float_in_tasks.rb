class ChangeFundsToFloatInTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :funds, :float, default: 0
  end
end
