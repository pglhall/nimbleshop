require File.expand_path('../boot', __FILE__)
#issue described in detail here: http://www.ruby-forum.com/topic/1002689 last comment
#rvm builds 1.9.2 with libyaml and it falls back to psych yaml parser
#psych is not working good with carmen gem
require 'yaml'
YAML::ENGINE.yamler= 'syck'

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Nimbleshop
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/validators)
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers = :order_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :'pt-BR'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # do not compress the assets for the time being
    config.assets.compress = false

    # do not use application for precompiling
    config.assets.initialize_on_precompile = false

    config.assets.precompile += ['admin.css', 'admin.js']

    # TODO we should do not need to hardcode theme name
    config.assets.paths << "#{Rails.root}/themes/simply/assets/stylesheets"
    config.assets.paths << "#{Rails.root}/themes/simply/assets/javascripts"
    config.assets.paths << "#{Rails.root}/themes/simply/assets/images"
    config.assets.precompile += ['simply.css', 'simply.js']


    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.generators do |g|
      g.test_framework :test_unit, fixture: false

      # do not generate a helper every time a controller is created
      g.helper = false
    end

  end
end
