class CreateTaskUploads < ActiveRecord::Migration
  def change
    create_table :task_uploads do |t|
      t.references :task, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
