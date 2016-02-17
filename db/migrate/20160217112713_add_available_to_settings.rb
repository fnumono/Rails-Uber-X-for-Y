class AddAvailableToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :available, :boolean, default: true
  end
end
