class ZoomMailWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false
	
	def perform(task_id, user_id, type)
		#sending mail
		group = Group.find_by(id: group_id)
		Array(group.users).each do |user|
			SecualEventMailer.secual_event(user.id, secual_event_id).deliver
		end
	end
end
