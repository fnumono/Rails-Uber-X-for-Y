class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :provider, index: true, foreign_key: true
      t.date :a1099
      t.date :noncompete
      t.date :confidentiality
      t.date :delivery

      t.timestamps null: false
    end
  end
end
