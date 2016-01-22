class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.datetime :datetime
      t.string :address
      t.float :addrlat
      t.float :addrlng
      t.string :contact
      t.text :details
      t.boolean :escrowable
      t.references :client, index: true, foreign_key: true
      t.references :provider, index: true, foreign_key: true
      t.references :type, index: true, foreign_key: true
      t.float :usedHour, default: 0
      t.float :usedEscrow, default: 0
      t.string :status, default: 'open'

      t.timestamps null: false
    end
  end
end
