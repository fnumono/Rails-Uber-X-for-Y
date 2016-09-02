class ZoomSmsSender

  def self.send_sms(receiver, content)
    if receiver.phone1.present?
      if receiver.phone1.first == '+'
        receiver_number = receiver.phone1
      else
        receiver_number = Settings.TWILIO_PHONE_PREFIX + receiver.phone1
      end

      twilio = Twilio::REST::Client.new
      twilio.account.messages.create(
        from: Settings.TWILIO_PHONE_NUMBER,
        to: receiver_number,
        body: content
      )
    end
  end

  def self.close_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client

    content = "Errand Completed!!! " +
      "Dear #{@client.fname} #{@client.lname}, " +
      "Your Errand #{@task.title} has been completed. " +
      "Hours Used: #{@task.usedHour}hrs, Escrow Used: $#{@task.usedEscrow}, " +
      "Your current available hours: #{@client.escrow_hour.hoursavail}hrs, " +
      "Your current escrow balance: $#{@client.escrow_hour.escrowavail}"

    self.send_sms(@client, content)
  end

  def self.job_alert_to_provider(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id)
    @client = @task.client
    @taskurl = Settings.angular_url + '/pages/jobalert?id=' + @task.id.to_s

    content = "Job Notification \"" + @task.try(:title).to_s + \
      "\", Datetime: " + @task.datetime.to_s + \
      ", Type: " + @task.type.name + \
      ", City: " + @task.city.to_s + \
      ". Click " + @taskurl + "  to accept job"

    self.send_sms(@provider, content)
  end

  def self.job_updated_to_provider(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id)
    @client = @task.client
    @taskurl = Settings.angular_url + '/provider/editjob?id=' + @task.id.to_s

    content = "Job changed \"" + @task.try(:title).to_s + \
      "\", Datetime: " + @task.datetime.to_s + \
      ", Type: " + @task.type.name + \
      ", City: " + @task.city.to_s + \
      ". Click " + @taskurl + "  to check the updated job"

    self.send_sms(@provider, content)
  end

  def self.job_awarded_to_provider(task_id, provider_id)
    @task = Task.find_by(id: task_id)
    @provider = Provider.find_by(id: provider_id)
    @client = @task.client
    @taskurl = Settings.angular_url + '/provider/editjob?id=' + @task.id.to_s

    content = "Congratulations!  Job awarded \"" + @task.try(:title).to_s + \
      "\", Datetime: " + @task.datetime.to_s + \
      ", Type: " + @task.type.name + \
      ", Location: " + @task.address + \
      ". Click " + @taskurl + "  to check the updated job"

    self.send_sms(@provider, content)
  end

  def self.status_update_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client

    content = "Errand status updated!!! " +
      "Dear #{@client.fname} #{@client.lname}, " +
      "Your Errand status has been updated."

    self.send_sms(@client, content)
  end

  def self.provider_update_to_client(task_id)
    @task = Task.find_by(id: task_id)
    @client = @task.client

    content = "Service provider selected!!! " +
      "Dear #{@client.fname} #{@client.lname}, " +
      "Service provider has been selected."

    self.send_sms(@client, content)
  end

  def self.hours_below_to_client(client_id)
    @client = Client.find_by(id: client_id)

    content = "Purchased hours are not enough " +
      "Dear #{@client.fname} #{@client.lname}, " +
      "Purchased hours are below #{@client.client_setting.try(:hours)}."

    self.send_sms(@client, content)
  end

  def self.funds_below_to_client(client_id)
    @client = Client.find_by(id: client_id)

    content = "Purchased funds are not enough " +
      "Dear #{@client.fname} #{@client.lname}, " +
      "Purchased funds are below $#{@client.client_setting.try(:funds)}."

    self.send_sms(@client, content)
  end

end

