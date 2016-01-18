class CreateZoomCounties < ActiveRecord::Migration
  def change
    create_table :zoom_counties do |t|
      t.string :longName
      t.string :shortName
      t.float :swLat
      t.float :swLng
      t.float :neLat
      t.float :neLng

      t.timestamps null: false
    end
  end
end
