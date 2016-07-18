# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github,        ENV['GITHUB_KEY'],   ENV['GITHUB_SECRET'],   scope: 'email,profile'
  provider :facebook,      Settings.facebook.key, Settings.facebook.secret
  provider :google_oauth2, Settings.google.key, Settings.google.secret
end
