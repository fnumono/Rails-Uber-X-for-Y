class AddNotificationToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :sms, :boolean, default: true
    add_column :settings, :email, :boolean, default: true
  end
end
