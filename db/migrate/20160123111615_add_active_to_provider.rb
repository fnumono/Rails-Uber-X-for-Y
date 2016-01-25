class AddActiveToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :active, :boolean, default: false
  end
end
