class AddZoomCityIdToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :zoom_city, index: true, foreign_key: true
  end
end
