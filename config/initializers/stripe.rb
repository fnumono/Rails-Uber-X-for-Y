Rails.configuration.stripe = {
  :publishable_key => Settings.stripe_publish_key,
  :secret_key      => Settings.stripe_secret_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]