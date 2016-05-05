require File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'

# require 'active_job/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module BundleApi
  class Application < Rails::Application
    config.api_only = true
    config.generators.test_framework = false
    config.middleware.insert_after(ActiveRecord::QueryCache, ActionDispatch::Cookies)
    config.middleware.insert_after(ActionDispatch::Cookies, ActionDispatch::Session::CookieStore)

    ActionMailer::Base.smtp_settings = {
      port: '587',
      address: ENV['BUNDLE_MANDRILL_ADDRESS'],
      user_name: ENV['BUNDLE_MANDRILL_USER_NAME'],
      password: ENV['BUNDLE_MANDRILL_PASSWORD'],
      authentication: :plain
    }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
      end
    end
  end
end
