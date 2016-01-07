class AddAttachmentUploadToTaskUploads < ActiveRecord::Migration
  def self.up
    change_table :task_uploads do |t|
      t.attachment :upload
    end
  end

  def self.down
    remove_attachment :task_uploads, :upload
  end
end
