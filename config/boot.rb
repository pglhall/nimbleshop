require 'rubygems'
require 'yaml'
YAML::ENGINE.yamler = 'syck'
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# Following line was added by Neeraj. Without this line delayed job was
# not working. For more details visit
# https://github.com/collectiveidea/delayed_job/issues/306
YAML::ENGINE.yamler = 'syck'

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
