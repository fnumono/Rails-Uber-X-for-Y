class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :percent, defaut: 0
      t.integer :cent, default: 0

      t.timestamps null: false
    end
  end
end
