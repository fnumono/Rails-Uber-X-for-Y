class CreateEscrowHours < ActiveRecord::Migration
  def change
    create_table :escrow_hours do |t|
      t.float :hoursavail, default: 0
      t.float :hoursused, default: 0
      t.float :escrowavail, default: 0
      t.float :escrowused, default: 0
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
