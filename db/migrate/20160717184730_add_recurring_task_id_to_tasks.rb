class AddRecurringTaskIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :recurring_task_id, :integer
  end
end
