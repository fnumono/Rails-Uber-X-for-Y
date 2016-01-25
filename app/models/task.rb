class Task < ActiveRecord::Base
  belongs_to :client
  belongs_to :provider
  belongs_to :type
  has_many :task_uploads, dependent: :destroy
  belongs_to :zoom_office

  accepts_nested_attributes_for :task_uploads, allow_destroy: true

  before_update :update_client_escrow_hour

  def attributes
  	a = super
  	a[:client] = nil
  	a[:provider] = nil
  	a[:type] = nil
    a[:task_uploads] = nil
  	a
  end

  protected

    def update_client_escrow_hour
      updated_hours = 0
      updated_escrow = 0
      if (self.status_changed?) && (self.status_was == 'open') && (self.status == 'close')
        updated_hours = self.usedHour - 0
        updated_escrow = self.usedEscrow - 0
      elsif (self.status_changed?) && (self.status_was == 'close') && (self.status == 'open')
        updated_hours = 0 - self.usedHour
        updated_escrow = 0 - self.usedEscrow  
      elsif (!self.status_changed?) && (self.status == 'close')
        updated_hours = self.usedHour - self.usedHour_was  
        updated_escrow = self.usedEscrow - self.usedEscrow_was  
      end
      self.client.escrow_hour.hoursavail -= updated_hours
      self.client.escrow_hour.hoursused += updated_hours
      self.client.escrow_hour.escrowavail -= updated_escrow
      self.client.escrow_hour.escrowused += updated_escrow 
      self.client.save!
    end
end