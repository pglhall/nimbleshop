# Encoding: UTF-8

$:.push File.expand_path('../../nimbleshop_core/lib', __FILE__)
require 'nimbleshop/version'
version = Nimbleshop::Version.to_s
rails_version = Nimbleshop::RailsVersion.to_s

Gem::Specification.new do |gem|

  gem.name              = 'nimbleshop_core'
  gem.version           = version
  gem.authors           = ['Neeraj Singh']
  gem.email             = 'neeraj@BigBinary.com'
  gem.homepage          = 'http://nimbleShop.org'

  gem.summary           = 'Core extension for nimbleShop'
  gem.description       = 'Provides core e-commerce support to nimbleShop'

  gem.files = Dir['{app,config,db,lib,vendor}/**/*'] + ['Rakefile', 'README.md']

  gem.test_files = Dir['test/**/*']

  gem.add_dependency 'rails', rails_version

  gem.add_dependency 'hashr', '= 0.0.19'

  gem.add_dependency 'carrierwave', '= 0.6.2'

  gem.add_dependency 'delayed_job_active_record', '= 0.3.2'

  gem.add_dependency 'twitter-bootstrap-rails', '= 2.1.0'

  gem.add_dependency 'state_machine', '= 1.1.2'

  gem.add_dependency 'mini_magick', '= 3.4'

  gem.add_dependency 'activemerchant', '= 1.23.0'

  gem.add_dependency 'carmen', '= 1.0.0.beta2'

  gem.add_dependency 'nested_form', '= 0.2.1'

  gem.add_dependency 'strong_parameters', '= 0.1.3'

  gem.add_dependency 'valid_email', '= 0.0.4'

  gem.add_dependency 'custom_error_message', '= 1.1.1'

  gem.add_dependency 'american_date', '= 1.0.0'
end
