class AddAttachmentDriverlicenseToProviders < ActiveRecord::Migration
  def self.up
    change_table :providers do |t|
      t.attachment :driverlicense
    end
  end

  def self.down
    remove_attachment :providers, :driverlicense
  end
end
