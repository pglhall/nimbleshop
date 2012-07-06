# Encoding: UTF-8

$:.push File.expand_path('../../nimbleshop_core/lib', __FILE__)
require 'nimbleshop/version'
version = Nimbleshop::Version.to_s

Gem::Specification.new do |gem|

  gem.name        = 'nimbleshop_paypalwp'
  gem.version     = version
  gem.authors     = ['Neeraj Singh']
  gem.email       = ['neeraj@bigbinary.com']
  gem.homepage    = 'http://nimbleShop.org'

  gem.summary     = 'Paypal WPS extension for nimbleshop'
  gem.description = 'Provides Paypal web payments standard support to nimbleshop'

  gem.files = Dir["{app,config,db,lib}/**/*"] + ['README.md']

  gem.test_files = Dir['test/**/*']

  gem.add_dependency 'activemerchant'
  gem.add_dependency 'valid_email'
  gem.add_dependency 'money'
  gem.add_dependency 'nimbleshop_core', "= #{version}"

end
