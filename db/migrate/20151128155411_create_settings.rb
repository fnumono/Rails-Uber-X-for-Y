class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :provider, index: true, foreign_key: true
      t.datetime :a1099
      t.datetime :noncompete
      t.datetime :confidentiality
      t.datetime :delivery

      t.timestamps null: false
    end
  end
end
