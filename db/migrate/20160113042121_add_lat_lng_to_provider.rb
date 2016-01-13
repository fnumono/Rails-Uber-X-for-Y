class AddLatLngToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :addrlat, :float
    add_column :providers, :addrlng, :float
  end
end
