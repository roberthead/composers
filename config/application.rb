require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Composers
  class Application < Rails::Application
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :rspec, fixture: false
      g.stylesheets     false
      g.javascripts     false
    end

    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => 'http://*.codepen.io',
      'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
