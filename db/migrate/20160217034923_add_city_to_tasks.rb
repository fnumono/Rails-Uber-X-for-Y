class AddCityToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :city, :string
  end
end
