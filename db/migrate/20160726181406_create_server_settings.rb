class CreateServerSettings < ActiveRecord::Migration
  def change
    create_table :server_settings do |t|
      t.float :price_per_hour

      t.timestamps null: false
    end
  end
end
