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

  def recurring_job_alert_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client  

    mail to: @client.email, subject: 'Recurring Job Alert'
  end

  def job_updated_to_provider(task_id, provider_id)
		@task = Task.find_by(id: task_id)
  	@provider = Provider.find_by(id: provider_id) 
  	@client = @task.client	
  	@taskurl = Settings.angular_url + '/provider/editjob?id=' + @task.id.to_s

    mail to: @provider.email, subject: 'Job Changed'
  end

  def job_awarded_to_provider(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id) 
    @client = @task.client  
    @taskurl = Settings.angular_url + '/provider/editjob?id=' + @task.id.to_s

    mail to: @provider.email, subject: 'Congratulations! Job Awarded.'
  end

  def status_update_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client    

    mail to: @client.email, subject: 'Your errand status has been updated'
  end

  def provider_update_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client    

    mail to: @client.email, subject: 'Service provider has been updated'
  end


  def hours_below_to_client(client_id)
    @client = Client.find_by(id: client_id)

    mail to: @client.email, subject: 'Purchased hours are not enough'
  end

  def funds_below_to_client(client_id)
    @client = Client.find_by(id: client_id)

    mail to: @client.email, subject: 'Purchased funds are not enough'
  end
end
