require 'yaml'

file            = Rails.root.join('config', 'application.yml')
hash            = YAML.load(ERB.new(File.read(file)).result)

common_hash = hash['common'] || {}
env_hash = hash[Rails.env.to_s] || {}

Settings = Hashr.new(common_hash.merge(env_hash))
