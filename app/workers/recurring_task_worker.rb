class RecurringTaskWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  recurrence { hourly }
  sidekiq_options :retry => false
  
  def perform
    Task.where(recurring_task_id: nil).where("frequency > 0").where("datetime >= ?", 1.month.ago).where("datetime <= ?", 1.hour.from_now).each do |task|
      if task.datetime + task.frequency.days <= 1.days.from_now
        recurring_task = Task.new
        recurring_task.client_id = task.client_id
        recurring_task.title = task.title
        recurring_task.datetime = task.datetime + task.frequency.days
        recurring_task.address = task.address
        recurring_task.addrlat = task.addrlat
        recurring_task.addrlng = task.addrlng
        recurring_task.contact = task.contact
        recurring_task.type_id = task.type_id
        recurring_task.details = task.details
        recurring_task.escrowable = task.escrowable
        recurring_task.zoom_office_id = task.zoom_office_id
        recurring_task.city = task.city
        recurring_task.frequency = task.frequency
        recurring_task.unit = task.unit
        recurring_task.funds = task.funds
        recurring_task.funds_details = task.funds_details
        recurring_task.pick_up_address = task.pick_up_address
        recurring_task.pick_up_addrlat = task.pick_up_addrlat
        recurring_task.pick_up_addrlng = task.pick_up_addrlng
        recurring_task.pick_up_unit = task.pick_up_unit
        recurring_task.item = task.item
        if recurring_task.save
          task.update_columns(recurring_task_id: recurring_task.id)
          ZoomNotificationMailer.delay_for(10.seconds).recurring_job_alert_to_client(recurring_task.id)
        end
      end
    end
  end
end
