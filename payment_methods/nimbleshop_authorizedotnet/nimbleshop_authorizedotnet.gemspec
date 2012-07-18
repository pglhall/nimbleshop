# Encoding: UTF-8

$:.push File.expand_path('../../../nimbleshop_core/lib', __FILE__)
require 'nimbleshop/version'
version = Nimbleshop::Version.to_s

Gem::Specification.new do |gem|

  gem.name        = 'nimbleshop_authorizedotnet'
  gem.version     = version
  gem.authors     = ['Neeraj Singh', 'megpha']
  gem.email       = ['neeraj@BigBinary.com']
  gem.homepage    = 'http://nimbleShop.org'

  gem.summary     = 'Authorize.net extension for nimbleshop'
  gem.description = 'Provides Authorize.net support to nimbleShop'

  gem.files = Dir['{app,config,db,lib}/**/*'] + ['README.md']

  gem.test_files = Dir['test/**/*']

  gem.add_dependency 'activemerchant'
end
