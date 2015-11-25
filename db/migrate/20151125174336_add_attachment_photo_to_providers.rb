class AddAttachmentPhotoToProviders < ActiveRecord::Migration
  def self.up
    change_table :providers do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :providers, :photo
  end
end
