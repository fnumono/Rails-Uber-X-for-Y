class AddZoomCountyIdToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :zoom_county, index: true, foreign_key: true
  end
end
