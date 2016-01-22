class ZoomSmsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(task_id, provider_id)
    twilio = Twilio::REST::Client.new
    task = Task.find(task_id)
    provider = Provider.find(provider_id)
        
      # begin
        if provider.phone1.first == '+'
          receiver_number = provider.phone1
        else
          receiver_number = Settings.TWILIO_PHONE_PREFIX+provider.phone1
        end
        content = "Job Notification " + task.title + \
                  " Datetime: " + task.datetime.to_s + \
                  " Type: " + task.type.name + \
                  " Location: " + task.address + \
                  ". Click " + Settings.angular_url + "/pages/jobalert?id=" + task_id.to_s + "  to accept job" 
        # binding.pry
        twilio.account.messages.create(
          from: Settings.TWILIO_PHONE_NUMBER,
          to: receiver_number,
          body: content
        )

        # twilio.calls.create(
        #   from: Settings.TWILIO_PHONE_NUMBER,
        #   to: Settings.TWILIO_PHONE_PREFIX+provider.phone1,
        #   url: 'http://zxc.cz:5000/sample_twiml.xml'
        # )
      # rescue
      #   next
      # end
     
  end
end