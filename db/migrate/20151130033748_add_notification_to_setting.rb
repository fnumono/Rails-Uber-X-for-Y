class AddNotificationToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :sms, :boolean
    add_column :settings, :email, :boolean
  end
end
