class CreateSettingsTypes < ActiveRecord::Migration
  def change
    create_table :settings_types, id: false do |t|
      t.references :setting, index: true, foreign_key: true
      t.references :type, index: true, foreign_key: true
    end
  end
end
