class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notify_type, default: 0
      t.string :name
      t.string :text
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
