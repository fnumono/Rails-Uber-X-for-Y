class Task < ActiveRecord::Base
  belongs_to :client
  belongs_to :provider
  belongs_to :type
  has_many :task_uploads, dependent: :destroy
  belongs_to :zoom_office

  accepts_nested_attributes_for :task_uploads, allow_destroy: true

  after_create :send_job_alert
  before_update :update_client_escrow_hour
  after_update :send_notifications

  validates_presence_of :type, :zoom_office, :datetime, :frequency, :address, :addrlat, :addrlng
  validates_presence_of :pick_up_address, if: "type.try(:name) == 'Delivery'"

  def attributes
  	a = super
  	a[:client] = nil
  	a[:provider] = nil
  	a[:type] = nil
    a[:task_uploads] = nil
  	a
  end

  protected
    def send_notifications
      if status_changed?
        if self.status == 'close'
          ZoomNotificationMailer.delay_for(5.seconds).close_to_provider(self.id) if provider.setting.try(:email).present?

          ZoomSmsSender.delay_for(5.seconds).close_to_client(self.id) if client.client_setting.try(:status_update_sms).present?
          #send both client and support
          ZoomNotificationMailer.delay_for(5.seconds).close_to_client(self.id) if client.client_setting.try(:status_update_email).present?
          ZoomNotificationMailer.delay_for(5.seconds).close_to_support(self.id)

          self.client.notifications.create(notify_type: Settings.notify_errand, name: 'Errand Completed', \
              text: 'Errand  ' + self.try(:title).to_s + ' has been completed. Hours used: ' + self.usedHour.to_s + \
              ', Escrow used: ' + self.usedEscrow.to_s)
        else
          ZoomSmsSender.delay_for(5.seconds).status_update_to_client(self.id) if client.client_setting.try(:status_update_sms).present?
          ZoomNotificationMailer.delay_for(5.seconds).status_update_to_client(self.id) if client.client_setting.try(:status_update_email).present?
        end
      elsif provider_id_changed?
        if provider_id == nil
          ZoomNotificationMailer.delay_for(5.seconds).provider_job_cancelled_to_support(self.id, self.provider_id_was)

          send_job_alert
        else
          ZoomSmsSender.delay_for(5.seconds).job_awarded_to_provider(self.id, self.provider_id) if provider.setting.try(:sms).present?
          # send award email to both prvider and support
          ZoomNotificationMailer.delay_for(5.seconds).job_awarded_to_provider(self.id, self.provider_id) if provider.setting.try(:email).present?
          ZoomNotificationMailer.delay_for(5.seconds).job_awarded_to_support(self.id, self.provider_id)

          ZoomSmsSender.delay_for(5.seconds).provider_update_to_client(self.id) if client.client_setting.try(:provider_update_sms).present?
          ZoomNotificationMailer.delay_for(5.seconds).provider_update_to_client(self.id) if client.client_setting.try(:provider_update_email).present?
        end
      else
        if self.status == 'open' && provider.present?
          ZoomSmsSender.delay_for(5.seconds).job_updated_to_provider(self.id, self.provider_id) if provider.setting.try(:sms).present?
          ZoomNotificationMailer.delay_for(5.seconds).job_updated_to_provider(self.id, self.provider_id) if provider.setting.try(:email).present?
        end
      end

    end

    def send_job_alert
      return true if self.provider.present?

      provider_ids = []
      providers = select_nearest_sametype_providers(5)
      providers.each do |provider|
        provider_ids << provider.id
        ZoomSmsSender.delay_for(5.seconds).job_alert_to_provider(self.id, provider.id) if provider.setting.try(:sms).present?
        ZoomNotificationMailer.delay_for(5.seconds).job_alert_to_provider(self.id, provider.id) if provider.setting.try(:email).present?
      end

      ZoomNotificationMailer.delay_for(5.seconds).job_alert_to_support(self.id, provider_ids)

      self.client.notifications.create(notify_type: Settings.notify_errand, name: 'New Errand Posted', \
            text: 'You posted a new errand ' + self.try(:title).to_s + '.')
    end

    def select_nearest_sametype_providers(limit)
      query = 'abs(addrlat-(' + self.addrlat.to_s + ')) + abs(addrlng-(' + self.addrlng.to_s + ')) AS dist'
      busy_provider_ids = Provider.joins(:tasks).where('tasks.status = ? and tasks.datetime >= ? and tasks.datetime <= ?', \
                              'open', self.datetime-2.hours, self.datetime+2.hours).pluck(:id).uniq
      providers = Provider.joins(:setting)\
                          .joins('INNER JOIN settings_types ON settings.id = settings_types.setting_id')\
                          .where.not(id: busy_provider_ids)\
                          .where('settings_types.type_id = ?', self.type_id)\
                          .where('settings.available = ?', true)\
                          .where(zoom_office: zoom_office)\
                          .where(active: true)\
                          .select(query,'providers.id').distinct.order("dist").limit(limit)
      providers
    end

    def update_client_escrow_hour
      updated_hours = 0
      updated_escrow = 0
      if (self.status_changed?) && (self.status_was == 'open') && (self.status == 'close')
        updated_hours = self.usedHour - 0
        updated_escrow = self.usedEscrow - 0 if self.escrowable
      elsif (self.status_changed?) && (self.status_was == 'close') && (self.status == 'open')
        updated_hours = 0 - self.usedHour
        updated_escrow = 0 - self.usedEscrow  if self.escrowable
      elsif (!self.status_changed?) && (self.status == 'close')
        updated_hours = self.usedHour - self.usedHour_was
        updated_escrow = self.usedEscrow - self.usedEscrow_was  if self.escrowable
      end
      self.client.escrow_hour.hoursavail -= updated_hours
      self.client.escrow_hour.hoursused += updated_hours
      self.client.escrow_hour.escrowavail -= updated_escrow
      self.client.escrow_hour.escrowused += updated_escrow

      if !(self.client.save)
        self.status = self.status_was
        self.usedHour = self.usedHour_was
        self.usedEscrow = self.usedEscrow_was
      end
    end
end