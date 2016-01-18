class AddZoomCountyIdToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :zoom_county, index: true, foreign_key: true
  end
end
