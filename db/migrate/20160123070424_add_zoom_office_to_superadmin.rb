class AddZoomOfficeToSuperadmin < ActiveRecord::Migration
  def change
    add_reference :superadmins, :zoom_office, index: true, foreign_key: true
  end
end
