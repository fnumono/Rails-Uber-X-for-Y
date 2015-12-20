class TasksTypesJoinTable < ActiveRecord::Migration
  def change
  	create_table :tasks_types, id: false do |t|
      t.integer :task_id
      t.integer :type_id
    end
  end
end
