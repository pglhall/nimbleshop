require 'yaml'
require "#{Rails.root}/lib/config_loader"

class ConfigLoader
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def load
    file            = Rails.root.join('config', filename)
    hash            = YAML.load(ERB.new(File.read(file)).result)

    common_hash = hash['common'] || {}
    env_hash = hash[Rails.env.to_s] || {}

    final_hash = common_hash.deep_merge(env_hash)
    Hashr.new(final_hash)
  end
end

Settings = ConfigLoader.new('application.yml').load

# this is neeed to make attach_picture work
class FilelessIO < StringIO
  attr_accessor :original_filename
end
