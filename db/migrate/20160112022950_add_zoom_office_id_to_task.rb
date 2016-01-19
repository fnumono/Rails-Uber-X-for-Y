class AddZoomOfficeIdToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :zoom_office, index: true, foreign_key: true
  end
end
