require File.expand_path('../boot', __FILE__)

# Issue described in detail here: http://www.ruby-forum.com/topic/1002689 . Please see last comment
# rvm builds 1.9.2 with libyaml and it falls back to psych yaml parser
# carmen gem fails with psych. Following two lines fixes the problem
require 'yaml'
YAML::ENGINE.yamler= 'syck'

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module RailsApp
  class Application < Rails::Application

    # Enable the asset pipeline
    config.assets.enabled = true

  end
end
