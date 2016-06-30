class CreateClientSettings < ActiveRecord::Migration
  def change
    create_table :client_settings do |t|
      t.references :client, index: true, foreign_key: true
      t.boolean :status_update_email, default: true
      t.boolean :status_update_sms, default: true
      t.boolean :provider_update_email, default: true
      t.boolean :provider_update_sms, default: true
      t.integer :hours, default: 1
      t.boolean :hours_email, default: true
      t.boolean :hours_sms, default: true
      t.float :funds, default: 0
      t.boolean :funds_email, default: true
      t.boolean :funds_sms, default: true

      t.timestamps null: false
    end
  end
end
