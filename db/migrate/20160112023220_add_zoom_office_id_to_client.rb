class AddZoomOfficeIdToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :zoom_office, index: true, foreign_key: true
  end
end
