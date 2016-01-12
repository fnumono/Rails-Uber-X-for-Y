class AddZoomCityIdToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :zoom_city, index: true, foreign_key: true
  end
end
