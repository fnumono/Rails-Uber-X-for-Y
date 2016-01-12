class AddZoomCityIdToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :zoom_city, index: true, foreign_key: true
  end
end
