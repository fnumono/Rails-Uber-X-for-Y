class AddCategoryToTaskUploads < ActiveRecord::Migration
  def change
    add_column :task_uploads, :category, :string
  end
end
