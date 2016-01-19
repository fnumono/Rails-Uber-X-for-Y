class AddZoomOfficeIdToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :zoom_office, index: true, foreign_key: true
  end
end
