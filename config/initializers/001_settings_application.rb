require 'yaml'
require "#{Rails.root}/lib/config_loader"

Settings = ConfigLoader.new('application.yml').load
