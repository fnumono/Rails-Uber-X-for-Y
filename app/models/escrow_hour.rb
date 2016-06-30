class EscrowHour < ActiveRecord::Base
  belongs_to :client
  after_update :send_notifications

  def send_notifications    
    if escrowavail_changed? && self.escrowavail < client.client_setting.try(:funds).to_f
      ZoomSmsSender.delay_for(5.seconds).funds_below_to_client(self.client_id) if client.client_setting.try(:funds_sms).present?
      ZoomNotificationMailer.delay_for(5.seconds).funds_below_to_client(self.client_id) if client.client_setting.try(:funds_email).present?          
    end

    if hoursavail_changed? && self.hoursavail < client.client_setting.try(:hours).to_f
      ZoomSmsSender.delay_for(5.seconds).hours_below_to_client(self.client_id) if client.client_setting.try(:hours_sms).present?
      ZoomNotificationMailer.delay_for(5.seconds).hours_below_to_client(self.client_id) if client.client_setting.try(:hours_email).present?          
    end
  end
end
