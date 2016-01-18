class AddZoomCountyIdToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :zoom_county, index: true, foreign_key: true
  end
end
