require 'yaml'

file            = Rails.root.join('config', 'application.yml')
hash            = YAML.load(ERB.new(File.read(file)).result)

# I am not using openstruct because it does not have each_pair method.
common_hash = hash['common'] || {}
env_hash = hash[Rails.env.to_s] || {}

Settings = common_hash.merge(env_hash)

class << Settings
  def method_missing m
    self[m.to_s]
  end
end
