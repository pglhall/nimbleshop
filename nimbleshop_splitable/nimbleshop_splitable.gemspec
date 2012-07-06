# Encoding: UTF-8

$:.push File.expand_path('../../nimbleshop_core/lib', __FILE__)
require 'nimbleshop/version'
version = Nimbleshop::Version.to_s

Gem::Specification.new do |gem|

  gem.name        = 'nimbleshop_splitable'
  gem.version     = version
  gem.authors     = ['Neeraj Singh']
  gem.email       = ['neeraj@BigBinary.com']
  gem.homepage    = 'http://nimbleShop.org'

  gem.summary     = 'Splitable extension for Nimbleshop'
  gem.description = 'Provides Splitable support to nimbleShop'

  gem.files = Dir['{app,config,db,lib}/**/*'] + ['README.md']

  gem.test_files = Dir['test/**/*']

  gem.add_dependency 'activemerchant'
  gem.add_dependency 'nimbleshop_core', "= #{version}"
end
