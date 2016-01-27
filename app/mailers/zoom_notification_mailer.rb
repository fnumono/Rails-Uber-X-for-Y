class ZoomNotificationMailer < ApplicationMailer
	def close_to_client(task_id)
		@task = Task.find_by(id: task_id)
  	@client = @task.client  	

    mail to: @client.email, subject: 'Your errand has been completed'
  end

  def close_to_provider(task_id)
		@task = Task.find_by(id: task_id)
  	@provider = @task.provider  	

    mail to: @provider.email, subject: 'Your Job has been completed'
  end

  def job_alert_to_provider(task_id, provider_id)
		@task = Task.find_by(id: task_id)
  	@provider = Provider.find_by(id: provider_id) 
  	@client = @task.client	
  	@taskurl = Settings.angular_url + '/pages/jobalert?id=' + @task.id.to_s

    mail to: @provider.email, subject: 'New Job Alert'
  end

  def job_updated_to_provider(task_id, provider_id)
		@task = Task.find_by(id: task_id)
  	@provider = Provider.find_by(id: provider_id) 
  	@client = @task.client	
  	@taskurl = Settings.angular_url + '/provider/edit_job?id=' + @task.id.to_s

    mail to: @provider.email, subject: 'Job Changed'
  end

  def job_awarded_to_provider(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id) 
    @client = @task.client  
    @taskurl = Settings.angular_url + '/provider/edit_job?id=' + @task.id.to_s

    mail to: @provider.email, subject: 'Congratulations! Job Awarded.'
  end
end
