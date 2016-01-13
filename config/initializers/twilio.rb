require 'twilio-ruby'

Twilio.configure do |config|
  config.account_sid = Settings.TWILIO_ACCOUNT_SID
  config.auth_token = Settings.TWILIO_AUTH_TOKEN
end