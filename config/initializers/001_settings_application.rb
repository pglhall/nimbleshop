require 'yaml'
require "#{Rails.root}/lib/config_loader"

Settings = ConfigLoader.new('application.yml').load

# this is neeed to make attach_picture work
class FilelessIO < StringIO
  attr_accessor :original_filename
end
