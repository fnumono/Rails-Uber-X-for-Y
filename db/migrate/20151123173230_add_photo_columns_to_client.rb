class AddPhotoColumnsToClient < ActiveRecord::Migration
  def up
    add_attachment :clients, :photo
  end

  def down
    remove_attachment :clients, :photo
  end
end
