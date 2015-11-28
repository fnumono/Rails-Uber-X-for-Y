class AddAttachmentProofinsuranceToProviders < ActiveRecord::Migration
  def self.up
    change_table :providers do |t|
      t.attachment :proofinsurance
    end
  end

  def self.down
    remove_attachment :providers, :proofinsurance
  end
end
