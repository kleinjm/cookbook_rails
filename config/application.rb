# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CookbookRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.action_mailer.default_url_options = {
      host: ENV.fetch("MAILER_HOST")
    }

    config.action_mailer.perform_deliveries = true

    # Don"t care if the mailer can"t send.
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_caching = false

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: ENV.fetch("MAILER_HOST"),
      user_name: ENV.fetch("GMAIL_USERNAME"),
      password: ENV.fetch("GMAIL_PASSWORD"),
      authentication: "plain",
      enable_starttls_auto: true
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch("COOKBOOK_VUE_HOST")
        resource "/api/*",
                 headers: :any,
                 methods: :any,
                 expose: %w[Authorization]
      end
    end

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
