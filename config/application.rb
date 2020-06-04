# frozen_string_literal: true

require_relative 'boot'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
# Somehow ActionText causes an autoloader deprecation warning in test. We're
# not currently using ActionText so let's avoid the warning for now.
# require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie' # We're using Webpack for all assets
# require 'rails/test_unit/railtie' # We're using RSpec

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GoClimateNeutral
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    custom_paths = %w[
      app/models/validators
      app/models/types
    ].map { |path| Rails.root.join(path) }
    config.eager_load_paths.push(*custom_paths)
    config.autoload_paths.push(*custom_paths)

    # Whitelist locales available for the application
    config.i18n.available_locales = [:en, :sv, :de]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [:en]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}')]

    config.generators do |g|
      g.test_framework :rspec
      g.controller_specs false
      g.helper_specs false
      g.observer_specs false
      g.routing_specs false
      g.view_specs false
    end

    config.exceptions_app = routes

    # Skylight
    config.skylight.logger = Logger.new(STDOUT)
  end
end
