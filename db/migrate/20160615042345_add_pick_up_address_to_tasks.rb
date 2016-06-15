class AddPickUpAddressToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :pick_up_address, :string
    add_column :tasks, :pick_up_addrlat, :float
    add_column :tasks, :pick_up_addrlng, :float
    add_column :tasks, :pick_up_unit, :string
    add_column :tasks, :item, :string
  end
end
