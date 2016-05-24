require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
        g.fixture_replacement   :factory_girl, dir: 'spec/factories'
    end
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :sidekiq
    #config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expipres_in: 60.minutes }
    # config.cache_store = :redis_store, 'redis://h:pdpnnhd1fo1rkvdgd8t0ngcejuv@ec2-54-235-163-223.compute-1.amazonaws.com:18949/0/cache', { expipres_in: 60.minutes }
    config.cache_store = :redis_store, "#{ENV['REDIS_URL']}/0/cache", { expipres_in: 60.minutes }
  end
end
