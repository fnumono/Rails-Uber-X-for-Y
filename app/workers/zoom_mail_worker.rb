class ZoomMailWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false
	
	def perform(task_id, user_id, type)
		if type == 'closed'		
			ZoomNotificationMailer.close_to_provider(task_id).deliver if Task.find_by(id: task_id).present?
			ZoomNotificationMailer.close_to_client(task_id).deliver if Task.find_by(id: task_id).present?
		elsif type == 'created'
			ZoomNotificationMailer.job_alert_to_provider(task_id, user_id).deliver	if Task.find_by(id: task_id).present?
		elsif type == 'updated'
			ZoomNotificationMailer.job_updated_to_provider(task_id, user_id).deliver if Task.find_by(id: task_id).present?
		elsif type == 'awarded'
			ZoomNotificationMailer.job_awarded_to_provider(task_id, user_id).deliver	if Task.find_by(id: task_id).present?
		end
	end
end