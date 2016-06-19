class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :client, index: true, foreign_key: true
      t.float :purchase_hour, default: 0
      t.float :purchase_escrow, default: 0

      t.timestamps null: false
    end
  end
end
