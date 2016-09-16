class ZoomNotificationMailer < ApplicationMailer
	def close_to_client(task_id)
		@task = Task.find_by(id: task_id)
  	@client = @task.client

    mail to: @client.email, subject: 'Your errand has been completed'
  end

  def close_to_support(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client

    mail to: Settings.support_email, subject: 'Your errand has been completed' do |format|
      format.text { render text: "Your errand has been completed!
                                  Job id: #{@task.id},
                                  datetime: #{@task.datetime},
                                  client: #{@task.client.try(:email)},
                                  provider: #{@task.provider.try(:email)}  " }
    end
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

  def job_alert_to_support(task_id, provider_ids)
    @task = Task.find_by(id: task_id)
    providers = Provider.where(id: provider_ids)
    @provider = providers.first
    @client = @task.client
    @taskurl = Settings.angular_url + '/pages/jobalert?id=' + @task.id.to_s

    if providers.length > 0
      mail(to: Settings.support_email,
        subject: '"New Job Alert" was sent to ' + providers.pluck(:email).to_sentence) do |format|
        format.html { render 'job_alert_to_provider' }
        format.text { render 'job_alert_to_provider' }
      end
    else
      mail(to: Settings.support_email,
        subject: 'There is no provider for this job ' + providers.pluck(:email).to_sentence) do |format|
        format.text { render text: "Job id: #{@task.id},
                                    datetime: #{@task.datetime},
                                    client: #{@task.client.email}  " }
      end
    end
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

    mail(to: @provider.email, subject: 'Congratulations! Job Awarded.')
  end

  def job_awarded_to_support(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id)
    @client = @task.client
    @taskurl = Settings.angular_url + '/provider/editjob?id=' + @task.id.to_s

    mail(to: Settings.support_email, subject: 'Congratulations! Job Awarded.') do |format|
      format.html { render 'job_awarded_to_provider' }
      format.text { render 'job_awarded_to_provider' }
    end
  end

  def provider_job_cancelled_to_support(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id)
    @client = @task.client
    @taskurl = Settings.angular_url + '/provider/editjob?id=' + @task.id.to_s

    mail(to: Settings.support_email, subject: 'Provider cancelled job.')  do |format|
      format.text { render text: "provider email: #{@provider.try(:email)},
                                  task id: #{@task.id},
                                  client email: #{@client.try(:email)}" }
    end
  end

  def status_update_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client

    mail to: @client.email, subject: 'Your errand status has been updated'
  end

  def provider_update_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client

    mail to: @client.email, subject: 'Service provider has been selected'
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
