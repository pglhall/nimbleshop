# Encoding: UTF-8

$:.push File.expand_path('../nimbleshop_core/lib', __FILE__)
require 'nimbleshop/version'
version = Nimbleshop::Version.to_s
rails_version = Nimbleshop::RailsVersion.to_s

Gem::Specification.new do |gem|

  gem.name              = 'nimbleshop'
  gem.version           = version
  gem.authors           = ['Neeraj Singh']
  gem.email             = 'neeraj@BigBinary.com'
  gem.homepage          = 'http://nimbleShop.org'

  gem.summary           = 'nimbleShop gem is a free and open source e-commerce framework based on ruby on rails'
  gem.description       = 'nimbleShop is a free and open source e-commerce framework based on ruby on rails'

  gem.files = Dir['{lib}/**/*'] + ['README.md']

  gem.add_dependency 'rails', rails_version

  gem.add_dependency 'nimbleshop_core',            "= #{version}"
  gem.add_dependency 'nimbleshop_simply',          "= #{version}"

  gem.add_dependency 'nimbleshop_authorizedotnet', "= #{version}"
  gem.add_dependency 'nimbleshop_paypalwp',        "= #{version}"
  gem.add_dependency 'nimbleshop_splitable',       "= #{version}"
  gem.add_dependency 'nimbleshop_cod',             "= #{version}"

end
