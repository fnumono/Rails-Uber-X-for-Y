class Task < ActiveRecord::Base
  belongs_to :client
  belongs_to :provider
  belongs_to :type
  has_many :task_uploads, dependent: :destroy
  belongs_to :zoom_office

  accepts_nested_attributes_for :task_uploads, allow_destroy: true

  after_create :send_job_alert_sms
  before_update :update_client_escrow_hour
  after_update :send_complete_notification_provider_client


  def attributes
  	a = super
  	a[:client] = nil
  	a[:provider] = nil
  	a[:type] = nil
    a[:task_uploads] = nil
  	a
  end

  protected
    def send_complete_notification_provider_client
      if (self.status == 'close')
        ZoomMailWorker.perform_in(2.seconds, self.id, 0, 'closed')
      end 
    end

    def send_job_alert_sms      
      providers = select_nearest_sametype_providers(5) 
      providers.find_each do |provider| 
        if provider.setting.sms
          ZoomSmsWorker.perform_in(2.seconds, self.id, provider.id, 'created') 
        end   
        if provider.setting.email
          ZoomMailWorker.perform_in(2.seconds, self.id, provider.id, 'created') 
        end
      end 
    end

    def select_nearest_sametype_providers(limit)
      query = 'abs(addrlat-(' + self.addrlat.to_s + ')) + abs(addrlng-(' + self.addrlng.to_s + ')) AS dist'
      providers = Provider.joins(:setting)\
                          .joins('INNER JOIN settings_types ON settings.id = settings_types.setting_id')\
                          .where('settings_types.type_id = ?', self.type_id)\
                          .where(active: true)
      providers = providers.select(query,'*').order("dist").limit(limit)
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