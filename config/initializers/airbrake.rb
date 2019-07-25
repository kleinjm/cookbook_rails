# frozen_string_literal: true

Airbrake.configure do |config|
  config.host = "https://errbit-kleinjm.herokuapp.com"
  config.project_id = 1 # required, but any positive integer works
  config.project_key = "d7720dd9bf32e8eac127859ee7debb2f"

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w[development test]
end
